//
//  Club Repository.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 8.01.24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

enum ClubRepositoryError: Error {
    case alreadyExists
    case networkError
    
    var localizedDescription: String {
        switch self {
        case .alreadyExists:
            "Club with this name already exists! Use a different name!"
        case .networkError:
            "Network connetion failed!"
        }
    }
}

protocol ClubRepository {
    func create(club: Club) async throws
    func getClub(clubId: String) async throws -> Club
    func searchClub(searchText: String) async throws -> [UserClubModel]
    func add(workout: Workout, for clubId: String) throws
    func add(participant: ClubUserModel, for workout: Workout) throws
    func getWorkouts(for clubId: String, on date: Date) async throws -> [Workout]
    func getAllWokrouts(for user: DBUser, on date: Date) async throws -> [Workout]
    func deleteWorkout(for clubId: String, with workoutId: String) throws
    func updateWorkout(for clubId: String, with workout: Workout) throws
    func sendJoinRequest(for clubId: String, from userId: String, with name: String) throws
    func getRequests(for clubId: String) async throws -> [ClubRequestModel]
    func accept(request: ClubRequestModel, from club: Club) throws
    func reject(request: ClubRequestModel, from club: Club) throws
}

extension Firestore: ClubRepository {
    func create(club: Club) async throws {
        do {
            if try await collection("clubs").document(club.clubName).getDocument().exists {
                throw ClubRepositoryError.alreadyExists
            }
            try collection("clubs").document(club.clubName).setData(from: club, merge: false)
        } catch {
            let error = error as NSError
            
            switch error.code {
            case FirestoreErrorCode.deadlineExceeded.rawValue:
                throw ClubRepositoryError.networkError
            default:
                throw ClubRepositoryError.alreadyExists
            }
            
        }
    }
    
    func getClub(clubId: String) async throws -> Club {
        try await collection("clubs").document(clubId).getDocument(as: Club.self)
    }
    
    func searchClub(searchText: String) async throws -> [UserClubModel] {
        let querySnapshot = try await collection("clubs").whereField("searchName", arrayContains: searchText.lowercased()).getDocuments()
        
        return try querySnapshot.documents.compactMap { document in
            let club = try document.data(as: Club.self)
            return UserClubModel(name: club.clubName, picture: club.picture)
        }
        
    }
    
    func add(workout: Workout, for clubId: String) throws {
        try collection("clubs").document(clubId).collection("workouts").document(workout.workoutId).setData(from: workout, merge: true)
    }
    
    func getWorkouts(for clubId: String, on date: Date) async throws -> [Workout] {
        let startDate = Calendar.current.startOfDay(for: date)
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
        
        let querySnapshot = try await collection("clubs").document(clubId).collection("workouts")
            .whereField("date", isGreaterThanOrEqualTo: startDate)
            .whereField("date", isLessThanOrEqualTo: endDate)
            .getDocuments()
        
        return try querySnapshot.documents.compactMap { document in
            try document.data(as: Workout.self)
        }
    }
    
    func getAllWokrouts(for user: DBUser, on date: Date) async throws -> [Workout] {
        var workouts: [Workout] = []
        for club in user.joinedClubs {
            workouts.append(contentsOf: try await getWorkouts(for: club.name, on: date))
        }
        return workouts
    }
    
    func deleteWorkout(for clubId: String, with workoutId: String) throws {
        collection("clubs").document(clubId).collection("workouts").document(workoutId).delete()
    }
    
    func updateWorkout(for clubId: String, with workout: Workout) throws {
        collection("clubs").document(clubId).collection("workouts").document(workout.workoutId).updateData([
            "title": workout.title,
            "description": workout.description,
            "date": workout.date
        ])
    }
    
    func sendJoinRequest(for clubId: String, from userId: String, with name: String) throws {
        let request = ClubRequestModel(clubID: clubId, userID: userId, userName: name)
        let userRequest = [
            "requestID": request.requestID,
            "clubID": clubId,
            "status": RequestStatus.pending.rawValue
        ]
        try collection("clubs").document(clubId).collection("requests").document(request.requestID).setData(from: request, merge: false)
        collection("users").document(userId).updateData([
            "requests": FieldValue.arrayUnion([userRequest])
        ])
    }
    
    func getRequests(for clubId: String) async throws -> [ClubRequestModel] {
        let querySnapshot = try await collection("clubs").document(clubId).collection("requests")
            .whereField("status", isEqualTo: "Pending")
            .getDocuments()
        
        return try querySnapshot.documents.compactMap { document in
            try document.data(as: ClubRequestModel.self)
        }
    }
    
    func accept(request: ClubRequestModel, from club: Club) throws {
        collection("clubs").document(request.clubID).collection("requests").document(request.requestID).updateData([
            "status" : RequestStatus.accepted.rawValue
        ])
        
        let member = [
            "userID": request.userID,
            "name": request.userName
        ]
        
        let joinedClub = [
            "name": club.clubName,
            "picture": club.picture
        ]
        let requestToRemove = [
            "requestID": request.requestID,
            "clubID": club.clubName,
            "status": RequestStatus.pending.rawValue
        ]
        collection("clubs").document(request.clubID).updateData([
            "members": FieldValue.arrayUnion([member])
        ])
        
        collection("users").document(request.userID).updateData([
            "joinedClubs": FieldValue.arrayUnion([joinedClub]),
            "requests": FieldValue.arrayRemove([requestToRemove])
        ])
    }
    
    func reject(request: ClubRequestModel, from club: Club) throws {
        let requestToRemove = [
            "requestID": request.requestID,
            "clubID": request.clubID
        ]
        collection("users").document(request.userID).updateData([
            "requests": FieldValue.arrayRemove([requestToRemove])
        ])
        collection("clubs").document(request.clubID).collection("requests").document(request.requestID).delete()
    }
    
    func add(participant: ClubUserModel, for workout: Workout) throws {
        let participantToAdd = [
            "userID": participant.userID,
            "name": participant.name
        ]
        collection("clubs").document(workout.clubId).collection("workouts").document(workout.workoutId).updateData([
            "participants": FieldValue.arrayUnion([participantToAdd])
        ])
    }
}



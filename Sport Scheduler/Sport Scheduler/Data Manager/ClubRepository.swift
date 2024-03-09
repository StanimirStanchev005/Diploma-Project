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
    
    func listenForClubChanges()
    func listenForRequestChanges(for club: String, onSuccess: @escaping ([ClubRequestModel]) -> Void)
}

class FirestoreClubRepository: ClubRepository {
    
    private let db = Firestore.firestore()
    
    func create(club: Club) async throws {
        do {
            let clubDocument = try await db.collection("clubs").document(club.id).getDocument()
            guard !clubDocument.exists else {
                throw ClubRepositoryError.alreadyExists
            }
            try clubDocument.reference.setData(from: club, merge: false)
        } catch {
            throw ClubRepositoryError.networkError
        }
    }
    
    func getClub(clubId: String) async throws -> Club {
        try await db.collection("clubs").document(clubId).getDocument(as: Club.self)
    }
    
    private func getAllClubs() async throws -> [Club] {
        let clubsSnapshot = try await db.collection("clubs").getDocuments()
        return try clubsSnapshot.documents.compactMap { document in
            try document.data(as: Club.self)
        }
    }
    
    func listenForClubChanges() {
        _ = db.collection("clubs")
            .addSnapshotListener { clubsSnapshot, error in
                guard let clubsSnapshot else {
                    print("An error was discoverd")
                    return
                }
                
                let clubDocuments = clubsSnapshot.documents
                
                guard !clubDocuments.isEmpty else {
                    print("There are no club changes")
                    return
                }
                /*
                 Create a class that will be ClubsProvider (or smt similar (adapter is also suitable)). This class should be initialised with a ClubsRepository and will provide features to access clubs data. The class will hook a snapshot listener and will store the clubs locally to decreaes the amount of requests to Firestore (it's expensive dude).
                 The class should provide "CLUB" based access as this repository now does. This repo should provide the data instead. All decoding and data manipulation should happen in the Provider. This will allow to test this new class and verify that local data manipulation is done right.
                 */
            }
    }
    
    func searchClub(searchText: String) async throws -> [UserClubModel] {
        let searchText = searchText.lowercased()
        let clubs = try await getAllClubs()
        return clubs.filter { club in
            club.clubName.lowercased().contains(searchText)
        }
        .map { club in
            UserClubModel(name: club.clubName, picture: club.picture)
        }
    }
    
    func add(workout: Workout, for clubId: String) throws {
        try db.collection("clubs").document(clubId).collection("workouts").document(workout.workoutId).setData(from: workout, merge: true)
    }
    
    func getWorkouts(for clubId: String, on date: Date) async throws -> [Workout] {
        let startDate = Calendar.current.startOfDay(for: date)
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
        
        let querySnapshot = try await db.collection("clubs").document(clubId).collection("workouts")
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
        db.collection("clubs").document(clubId).collection("workouts").document(workoutId).delete()
    }
    
    func updateWorkout(for clubId: String, with workout: Workout) throws {
        db.collection("clubs").document(clubId).collection("workouts").document(workout.workoutId).updateData([
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
        try db.collection("clubs").document(clubId).collection("requests").document(request.requestID).setData(from: request, merge: false)
        db.collection("users").document(userId).updateData([
            "requests": FieldValue.arrayUnion([userRequest])
        ])
    }
    
    func getRequests(for clubId: String) async throws -> [ClubRequestModel] {
        let querySnapshot = try await db.collection("clubs").document(clubId).collection("requests")
            .whereField("status", isEqualTo: "Pending")
            .getDocuments()
        
        return try querySnapshot.documents.compactMap { document in
            try document.data(as: ClubRequestModel.self)
        }
    }
    
    func listenForRequestChanges(for club: String, onSuccess: @escaping ([ClubRequestModel]) -> Void) {
        _ = db.collection("clubs").document(club).collection("requests").addSnapshotListener { requestSnapshot, error in
            guard let requestSnapshot else {
                print("Error listening to request changes")
                return
            }
            
            let requestDocuments = requestSnapshot.documents
            
            guard !requestDocuments.isEmpty else {
                print("There are no request changes")
                return
            }
            print("Requests")
            print(requestDocuments)
            
            let requests = requestDocuments.compactMap { request in
                do {
                    return try request.data(as: ClubRequestModel.self)
                } catch {
                    print("Error decoding requests")
                    return nil
                }
            }
            onSuccess(requests)
        }
    }
    
    func accept(request: ClubRequestModel, from club: Club) throws {
        db.collection("clubs").document(request.clubID).collection("requests").document(request.requestID).updateData([
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
        db.collection("clubs").document(request.clubID).updateData([
            "members": FieldValue.arrayUnion([member])
        ])
        
        db.collection("users").document(request.userID).updateData([
            "joinedClubs": FieldValue.arrayUnion([joinedClub]),
            "requests": FieldValue.arrayRemove([requestToRemove])
        ])
    }
    
    func reject(request: ClubRequestModel, from club: Club) throws {
        let requestToRemove = [
            "requestID": request.requestID,
            "clubID": club.clubName,
            "status": RequestStatus.pending.rawValue
        ]
        db.collection("users").document(request.userID).updateData([
            "requests": FieldValue.arrayRemove([requestToRemove])
        ])
        db.collection("clubs").document(request.clubID).collection("requests").document(request.requestID).delete()
    }
    
    func add(participant: ClubUserModel, for workout: Workout) throws {
        let participantToAdd = [
            "userID": participant.userID,
            "name": participant.name
        ]
        db.collection("clubs").document(workout.clubId).collection("workouts").document(workout.workoutId).updateData([
            "participants": FieldValue.arrayUnion([participantToAdd])
        ])
    }
}




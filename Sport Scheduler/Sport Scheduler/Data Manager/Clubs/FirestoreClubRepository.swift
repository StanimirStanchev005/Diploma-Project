//
//  FirestoreClubsRepository.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 9.03.24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

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
            throw ClubRepositoryError.alreadyExists
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
    
    func listenForClubChanges(onSuccess: @escaping ([Club]) -> Void) {
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
                let clubs = clubDocuments.compactMap { club in
                    do {
                        return try club.data(as: Club.self)
                    } catch {
                        print("Error decoding club: \(club)")
                        return nil
                    }
                }
                onSuccess(clubs)
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
            
            var requests: [ClubRequestModel] = []
            
            guard !requestDocuments.isEmpty else {
                return
            }
            requests = requestDocuments.compactMap { request in
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
    
    func listenForChanges(for club: String, onSuccess: @escaping (Club) -> Void) {
        db.collection("clubs").document(club).addSnapshotListener { clubSnapshot, error in
            guard let clubSnapshot else {
                print("Error listening to request changes")
                return
            }
            do {
                let club = try clubSnapshot.data(as: Club.self)
                onSuccess(club)
            } catch {
                print("Error decoding club: \(club)")
            }
        }
    }
    
    func accept(request: ClubRequestModel, from club: Club) throws {
        let member = [
            "userID": request.userID,
            "name": request.userName,
            "visitedWorkouts": 0
        ] as [String : Any]
        
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
        db.collection("clubs").document(request.clubID).collection("requests").document(request.requestID).delete()
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
        let participantToRemove = [
            "userID": participant.userID,
            "name": participant.name,
            "visitedWorkouts": participant.visitedWorkouts
        ] as [String : Any]
        
        let participantToAdd = [
            "userID": participant.userID,
            "name": participant.name,
            "visitedWorkouts": participant.visitedWorkouts + 1
        ] as [String : Any]
        
        db.collection("clubs").document(workout.clubId).collection("workouts").document(workout.workoutId).updateData([
            "participants": FieldValue.arrayUnion([participantToAdd])
        ])
    
        db.collection("clubs").document(workout.clubId).updateData([
            "members": FieldValue.arrayRemove([participantToRemove])
        ])
        db.collection("clubs").document(workout.clubId).updateData([
            "members": FieldValue.arrayUnion([participantToAdd])
        ])
       
    }
    
    func remove(user: ClubUserModel, from club: Club) throws {
        let userToRemove = [
            "userID": user.userID,
            "name": user.name,
            "visitedWorkouts": user.visitedWorkouts
        ] as [String : Any]
        
        db.collection("clubs").document(club.id).updateData([
            "members": FieldValue.arrayRemove([userToRemove])
        ])
        let clubToRemove = [
            "name": club.clubName,
            "picture": club.picture
        ]
        db.collection("users").document(user.userID).updateData([
            "joinedClubs": FieldValue.arrayRemove([clubToRemove])
        ])
    }
}




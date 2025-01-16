//
//  FirestoreClubsRepository.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 9.03.24.
//

import Foundation
@preconcurrency import FirebaseFirestore
import FirebaseFirestoreSwift

actor FirestoreClubRepository: ClubRepository {

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
        return try await db.collection("clubs").document(clubId).getDocument(as: Club.self)

    }

    private func getAllClubs() async throws -> [Club] {
        let clubsSnapshot = try await db.collection("clubs").getDocuments()
        return try clubsSnapshot.documents.compactMap { document in
            try document.data(as: Club.self)
        }
    }

    func listenForClubChanges() async throws -> AsyncThrowingStream<[Club], Error> {
        AsyncThrowingStream { continuation in
            _ = db.collection("clubs")
                .addSnapshotListener { clubsSnapshot, error in

                    guard error == nil else {
                        continuation.finish(throwing: error)
                        return
                    }

                    guard let clubsSnapshot else {
                        continuation.finish(throwing: "Club snapshot not found or nil!")
                        return
                    }

                    let clubDocuments = clubsSnapshot.documents

                    guard !clubDocuments.isEmpty else {
                        continuation.finish(throwing: "There are no club changes!")
                        return
                    }

                    let clubs = clubDocuments.compactMap { club in
                        do {
                            return try club.data(as: Club.self)
                        } catch {
                            continuation.finish(throwing: "Error decoding club: \(club)")
                            return nil
                        }
                    }
                    continuation.yield(clubs)
                    continuation.finish()
                }
        }
    }

    func add(workout: Workout, for clubId: String) async throws {
        try db.collection("clubs").document(clubId).collection("workouts").document(workout.workoutId).setData(from: workout, merge: true)
    }

    func deleteWorkout(for clubId: String, with workoutId: String) async throws {
        try await db.collection("clubs").document(clubId).collection("workouts").document(workoutId).delete()
    }

    func updateWorkout(for clubId: String, with workout: Workout) async throws {
        try await db.collection("clubs").document(clubId).collection("workouts").document(workout.workoutId).updateData([
            "title": workout.title,
            "description": workout.description,
            "date": workout.date
        ])
    }

    func sendJoinRequest(for clubId: String, from userId: String, with name: String) async throws {
        let request = ClubRequestModel(clubID: clubId, userID: userId, userName: name)
        let userRequest = [
            "requestID": request.requestID,
            "clubID": clubId,
            "status": RequestStatus.pending.rawValue
        ]
        try db.collection("clubs").document(clubId).collection("requests").document(request.requestID).setData(from: request, merge: false)
        try await db.collection("users").document(userId).updateData([
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

    func listenForRequestChanges(for club: String) async throws -> AsyncThrowingStream<[ClubRequestModel], Error> {
        AsyncThrowingStream { continuation in
            db.collection("clubs").document(club).collection("requests").addSnapshotListener { requestSnapshot, error in

                guard let requestSnapshot else {
                    continuation.finish(throwing: "Error listening to request changes")
                    return
                }

                let requestDocuments = requestSnapshot.documents
                var requests: [ClubRequestModel] = []

                guard !requestDocuments.isEmpty else {
                    continuation.finish(throwing: "Request documents are empty!")
                    return
                }

                requests = requestDocuments.compactMap { request in
                    do {
                        return try request.data(as: ClubRequestModel.self)
                    } catch {
                        continuation.finish(throwing: "Error decoding requests")
                        return nil
                    }
                }
                continuation.yield(requests)
                continuation.finish()
            }
        }
    }

    func listenForChanges(for club: String) async throws -> AsyncThrowingStream<Club, Error> {
        AsyncThrowingStream { continuation in
            db.collection("clubs").document(club).addSnapshotListener { clubSnapshot, error in
                guard let clubSnapshot else {
                    continuation.finish(throwing: "Error listening to request changes")
                    return
                }
                do {
                    let club = try clubSnapshot.data(as: Club.self)
                    continuation.yield(club)
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: "Error decoding club: \(club)")
                }
            }
        }
    }

    func getWorkouts(for club: String, lastDocument: DocumentSnapshot?, history: Bool) async throws -> ([Workout], lastDocument: DocumentSnapshot?) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let startDate = calendar.date(from: components)!
        if let lastDocument {
            return try await db.collection("clubs").document(club).collection("workouts")
                .order(by: "date", descending: history)
                .limit(to: 5)
                .start(afterDocument: lastDocument)
                .getDocumentsWithSnapshot(as: Workout.self)
        } else {
            return try await db.collection("clubs").document(club).collection("workouts")
                .order(by: "date", descending: history)
                .limit(to: 5)
                .start(at: [startDate])
                .getDocumentsWithSnapshot(as: Workout.self)
        }
    }

    func accept(request: ClubRequestModel, from club: Club) async throws {
        let member = [
            "userID": request.userID,
            "name": request.userName,
            "visitedWorkouts": 0
        ] as [String : Any]

        let requestToRemove = [
            "requestID": request.requestID,
            "clubID": club.clubName,
            "status": RequestStatus.pending.rawValue
        ]
        try await db.collection("clubs").document(request.clubID).updateData([
            "members": FieldValue.arrayUnion([member])
        ])
        try await db.collection("users").document(request.userID).updateData([
            "joinedClubs": FieldValue.arrayUnion([club.clubName]),
            "requests": FieldValue.arrayRemove([requestToRemove])
        ])
        try await db.collection("clubs").document(request.clubID).collection("requests").document(request.requestID).delete()
    }

    func reject(request: ClubRequestModel, from club: Club) async throws {
        let requestToRemove = [
            "requestID": request.requestID,
            "clubID": club.clubName,
            "status": RequestStatus.pending.rawValue
        ]
        try await db.collection("users").document(request.userID).updateData([
            "requests": FieldValue.arrayRemove([requestToRemove])
        ])
        try await db.collection("clubs").document(request.clubID).collection("requests").document(request.requestID).delete()
    }

    func add(participant: ClubUserModel, for workout: Workout, from club: Club) async throws {
        let participantToAdd = [
            "userID": participant.userID,
            "name": participant.name,
            "visitedWorkouts": participant.visitedWorkouts + 1
        ] as [String : Any]

        try await db.collection("clubs").document(workout.clubId).collection("workouts").document(workout.workoutId).updateData([
            "participants": FieldValue.arrayUnion([participantToAdd])
        ])

        let memberIndex = club.members.firstIndex { member in
            participant.userID == member.userID
        }
        guard let memberIndex else {
            print("This user is not a member in this club")
            return
        }
        var updatedClub = club
        updatedClub.members[memberIndex].visitedWorkouts += 1


        try db.collection("clubs").document(workout.clubId).setData(from: updatedClub, merge: true)
    }

    func remove(user: ClubUserModel, from club: Club) async throws {
        let userToRemove = [
            "userID": user.userID,
            "name": user.name,
            "visitedWorkouts": user.visitedWorkouts
        ] as [String : Any]

        try await db.collection("clubs").document(club.id).updateData([
            "members": FieldValue.arrayRemove([userToRemove])
        ])
        try await db.collection("users").document(user.userID).updateData([
            "joinedClubs": FieldValue.arrayRemove([club.clubName])
        ])
    }

    func updateClubPicture(clubID: String, pictureUrl: String) async throws {
        try await db.collection("clubs").document(clubID).updateData([
            "picture": pictureUrl
        ])
    }
}

extension Query {
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        try await getDocumentsWithSnapshot(as: type).workouts
    }

    func getDocumentsWithSnapshot<T>(as type: T.Type) async throws -> (workouts: [T], lastDocument: DocumentSnapshot?) where T : Decodable {
        let snapshot = try await self.getDocuments()

        let workouts = try snapshot.documents.map { document in
            try document.data(as: T.self)
        }
        return (workouts, snapshot.documents.last)
    }
}


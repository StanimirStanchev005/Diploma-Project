//
//  FirestoreUserRepository.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 9.03.24.
//

import Foundation
@preconcurrency import FirebaseFirestore
import FirebaseFirestoreSwift

actor FirestoreUserRepository: UserRepository {
    private let db = Firestore.firestore()


    
    func listenForUserChanges(for userID: String) async throws -> AsyncThrowingStream<DBUser, Error> {
        AsyncThrowingStream<DBUser, Error> { continuation in
            let listener = db.collection("users").document(userID).addSnapshotListener { userSnapshot, error in
                if let error {
                    continuation.finish(throwing: error)
                    return
                }
                guard let userSnapshot else {
                    continuation.finish(throwing: "Error listening to user changes")
                    return
                }
                do {
                    let user = try userSnapshot.data(as: DBUser.self)
                    continuation.yield(user)
                    continuation.finish()
                } catch let error {
                    continuation.finish(throwing: error)
                }
            }

            continuation.onTermination = { _ in
                listener.remove()
            }
        }
    }
    
    func create(user: DBUser) async throws {
        try db.collection("users").document(user.userID).setData(from: user, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await db.collection("users").document(userId).getDocument(as: DBUser.self)
    }
    
    func checkIfUserExists(userId: String) async throws -> Bool {
        let querySnapshot = db.collection("users").document(userId)
        do {
            let document = try await querySnapshot.getDocument().data()
            return document != nil
        } catch {
            print("Error fetching document: \(error)")
            return false
        }
    }
    
    func save(user: DBUser) async throws {
        try db.collection("users").document(user.userID).setData(from: user, merge: true)
    }
    
    func addClub(for userID: String, clubName: String) async throws {
        try await db.collection("users").document(userID).updateData([
            "ownedClubs": FieldValue.arrayUnion([clubName])
        ])
    }
    
    func upgrade(plan: PremiumPlan, for userID: String) async throws {
        let upgradePlan = [
            "title": plan.title,
            "tier": plan.tier,
            "extras": plan.extras,
            "price": plan.price
        ] as [String : Any]
        
        try await db.collection("users").document(userID).updateData([
            "subscriptionPlan": upgradePlan
        ])
    }
}

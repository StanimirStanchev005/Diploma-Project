//
//  FirestoreUserRepository.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 9.03.24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreUserRepository: UserRepository {
    private let db = Firestore.firestore()
    
    func listenForUserChanges(for userID: String, onSuccess: @escaping (DBUser) -> Void) {
        db.collection("users").document(userID).addSnapshotListener { userSnapshot, error in
            guard let userSnapshot else {
                print("Error listening to user changes")
                return
            }
            do {
                let user = try userSnapshot.data(as: DBUser.self)
                onSuccess(user)
            } catch {
                print("Error decoding user")
            }
        }
    }
    
    func create(user: DBUser) throws {
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
    
    func save(user: DBUser) throws {
        try db.collection("users").document(user.userID).setData(from: user, merge: true)
    }
    
    func addClub(for userID: String, clubName: String, clubPicture: String) throws {
        let club = ["name": clubName,
                    "picture": clubPicture]
        db.collection("users").document(userID).updateData([
            "ownedClubs": FieldValue.arrayUnion([club])
        ])
    }
    
    func upgrade(plan: PremiumPlan, for userID: String) throws {
        let upgradePlan = [
            "title": plan.title,
            "tier": plan.tier,
            "extras": plan.extras,
            "price": plan.price
        ] as [String : Any]
        
        db.collection("users").document(userID).updateData([
            "subscriptionPlan": upgradePlan
        ])
    }
}

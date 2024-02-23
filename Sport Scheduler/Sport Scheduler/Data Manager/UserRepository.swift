//
//  UserManager.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 12.12.23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol UserRepository {
    func create(user: DBUser) throws
    func getUser(userId: String) async throws -> DBUser
    func save(user: DBUser) throws
    func addClub(for userID: String, clubName: String, clubPicture: String) throws
}

extension Firestore: UserRepository {
    func create(user: DBUser) throws {
        try collection("users").document(user.userID).setData(from: user, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await collection("users").document(userId).getDocument(as: DBUser.self)
    }
    
    func save(user: DBUser) throws {
        try collection("users").document(user.userID).setData(from: user, merge: true)
    }
    
    func addClub(for userID: String, clubName: String, clubPicture: String) throws {
        let club = ["name": clubName,
                    "picture": clubPicture]
        collection("users").document(userID).updateData([
            "ownedClubs": FieldValue.arrayUnion([club])
        ])
    }
}

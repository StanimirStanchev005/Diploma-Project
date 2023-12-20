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
}

extension Firestore: UserRepository {
    func create(user: DBUser) throws {
        try collection("users").document(user.userID).setData(from: user, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await collection("users").document(userId).getDocument(as: DBUser.self)
    }
}

final class UserManager {
    
    var databaseProvider: UserRepository
    
    init(databaseProvider: UserRepository = Firestore.firestore()) {
        self.databaseProvider = databaseProvider
    }
        
    func createNewUser(user: DBUser) throws {
        try databaseProvider.create(user: user)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await databaseProvider.getUser(userId: userId)
    }
}

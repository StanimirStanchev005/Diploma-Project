//
//  UserManager.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 12.12.23.
//

import Foundation

protocol UserRepository {
    func create(user: DBUser) throws
    func getUser(userId: String) async throws -> DBUser
    func checkIfUserExists(userId: String) async throws -> Bool
    func save(user: DBUser) throws
    func addClub(for userID: String, clubName: String, clubPicture: String) throws
    func upgrade(plan: PremiumPlan, for userID: String) throws
    
    func listenForUserChanges(for userID: String, onSuccess: @escaping (DBUser) -> Void)
}


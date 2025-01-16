//
//  UserManager.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 12.12.23.
//

import Foundation

protocol UserRepository: Sendable {
    func create(user: DBUser) async throws
    func getUser(userId: String) async throws -> DBUser
    func checkIfUserExists(userId: String) async throws -> Bool
    func save(user: DBUser) async throws
    func addClub(for userID: String, clubName: String) async throws
    func upgrade(plan: PremiumPlan, for userID: String) async throws
    
    func listenForUserChanges(for userID: String) async throws -> AsyncThrowingStream<DBUser, Error>
}


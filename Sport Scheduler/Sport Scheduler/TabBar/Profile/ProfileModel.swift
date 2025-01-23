//
//  ProfileModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 13.12.23.
//

import FirebaseFirestore
import FirebaseAuth

final class ProfileModel {
    
    private var authenticationProvider: AuthenticationServiceProvidable
    private var databaseProvider: UserRepository
    
    init(authenticationProvider: AuthenticationServiceProvidable = FirebaseAuthenticationProvider(), databaseProvider: UserRepository = FirestoreUserRepository()) {
        self.authenticationProvider = authenticationProvider
        self.databaseProvider = databaseProvider
    }
    
    func laodCurrentUser() async throws -> DBUser {
        let authDataResult = try await authenticationProvider.getAuthenticatedUser()
        return try await databaseProvider.getUser(userId: authDataResult.uid)
    }
    
    @MainActor func signOut() async throws {
        try await authenticationProvider.signOut()
    }
}

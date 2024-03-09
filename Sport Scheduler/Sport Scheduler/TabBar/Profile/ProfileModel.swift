//
//  ProfileModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 13.12.23.
//

import FirebaseFirestore
import FirebaseAuth

@MainActor
final class ProfileModel: ObservableObject {
    
    private var authenticationProvider: AuthenticationServiceProvidable
    private var databaseProvider: UserRepository
    
    init(authenticationProvider: AuthenticationServiceProvidable = Auth.auth(), databaseProvider: UserRepository = FirestoreUserRepository()) {
        self.authenticationProvider = authenticationProvider
        self.databaseProvider = databaseProvider
    }
    
    func laodCurrentUser() async throws -> DBUser {
        let authDataResult = try authenticationProvider.getAuthenticatedUser()
        return try await databaseProvider.getUser(userId: authDataResult.uid)
    }
    
    func signOut() throws {
        try authenticationProvider.signOut()
    }
}

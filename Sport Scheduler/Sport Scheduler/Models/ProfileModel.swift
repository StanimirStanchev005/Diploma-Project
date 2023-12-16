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
    
    @Published private(set) var user: DBUser? = nil
    
    private var authenticationProvider: AuthenticationServiceProvidable
    private var databaseProvider: DatabaseServiceProvidable
    
    init(authenticationProvider: AuthenticationServiceProvidable = Auth.auth(), databaseProvider: DatabaseServiceProvidable = Firestore.firestore()) {
        self.authenticationProvider = authenticationProvider
        self.databaseProvider = databaseProvider
    }
    
    func laodCurrentUser() async throws {
        let authDataResult = try authenticationProvider.getAuthenticatedUser()
        self.user = try await databaseProvider.getUser(userId: authDataResult.uid)
    }
    
    func signOut() throws {
        try authenticationProvider.signOut()
    }
}

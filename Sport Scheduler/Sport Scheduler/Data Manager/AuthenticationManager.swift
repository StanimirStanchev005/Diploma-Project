//
//  AuthenticationManager.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 12.12.23.
//

import Foundation
import FirebaseAuth

protocol AuthenticationServiceProvidable {
    func signOut() throws
    func getAuthenticatedUser() throws -> AuthDataResultModel
    func signUp(email: String, password: String) async throws -> AuthDataResultModel
    func signIn(email: String, password: String) async throws -> AuthDataResultModel
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel
}

extension Auth: AuthenticationServiceProvidable {
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken,
                                                       accessToken: tokens.accessToken)
        return try await signIn(credential: credential)
    }
    
    func signUp(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func signIn(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
}

struct AuthDataResultModel {
    let uid: String
    let name: String?
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.name = user.displayName
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

final class AuthenticationManager {
    
    var authenticationProvider: AuthenticationServiceProvidable
    
    init(authenticationProvider: AuthenticationServiceProvidable = Auth.auth()) {
        self.authenticationProvider = authenticationProvider
    }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        try authenticationProvider.getAuthenticatedUser()
    }
    
    func signOut() throws {
        try authenticationProvider.signOut()
    }
}

//Sign in with email and password
extension AuthenticationManager {
    func signUp(email: String, password: String) async throws -> AuthDataResultModel {
        try await authenticationProvider.signUp(email: email, password: password)
    }
    
    func signIn(email: String, password: String) async throws -> AuthDataResultModel {
        try await authenticationProvider.signIn(email: email, password: password)
    }
}

// Sign in with Google
extension AuthenticationManager {
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        try await authenticationProvider.signInWithGoogle(tokens: tokens)
    }
    
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
        try await authenticationProvider.signIn(credential: credential)
    }
}

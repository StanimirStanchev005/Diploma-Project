//
//  AuthenticationServiceProvidable.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 9.03.24.
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

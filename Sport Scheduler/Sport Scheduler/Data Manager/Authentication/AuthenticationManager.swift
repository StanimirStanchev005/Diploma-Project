//
//  AuthenticationManager.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 12.12.23.
//

import Foundation
import FirebaseAuth

class FirebaseAuthenticationProvider: AuthenticationServiceProvidable {
    private let auth = Auth.auth()
    
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken,
                                                       accessToken: tokens.accessToken)
        return try await signIn(credential: credential)
    }
    
    func signUp(email: String, password: String) async throws -> AuthDataResultModel {
        do {
            let authDataResult = try await auth.createUser(withEmail: email, password: password)
            return AuthDataResultModel(user: authDataResult.user)
        } catch {
            let error = error as NSError
            switch error.code {
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                throw AuthError.emailAlreadyInUse
            case AuthErrorCode.networkError.rawValue:
                throw AuthError.networkError
            default:
                throw AuthError.networkError
            }
        }
    }
    
    func signIn(email: String, password: String) async throws -> AuthDataResultModel {
        do {
            let authDataResult = try await auth.signIn(withEmail: email, password: password)
            return AuthDataResultModel(user: authDataResult.user)
        } catch {
            let error = error as NSError
            switch error.code {
            case AuthErrorCode.invalidEmail.rawValue:
                throw AuthError.invalidEmailOrPassword
            case AuthErrorCode.wrongPassword.rawValue:
                throw AuthError.invalidEmailOrPassword
            case AuthErrorCode.networkError.rawValue:
                throw AuthError.networkError
            default:
                throw AuthError.invalidEmailOrPassword
            }
        }
    }
    
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
        do {
            let authDataResult = try await auth.signIn(with: credential)
            return AuthDataResultModel(user: authDataResult.user)
        } catch {
            let error = error as NSError
            switch error.code {
            case AuthErrorCode.networkError.rawValue:
                throw AuthError.networkError
            default:
                throw AuthError.networkError
            }
        }
    }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = auth.currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
    
    func signOut() throws {
        try auth.signOut()
    }
}



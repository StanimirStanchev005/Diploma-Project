//
//  AuthenticationManager.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 12.12.23.
//

import Foundation
import FirebaseAuth

enum AuthError: Error {
    case emailAlreadyInUse
    case networkError
    case invalidEmailOrPassword
    
    var localizedDescription: String {
        switch self {
            
        case .emailAlreadyInUse:
            "This email is already in use! Use a different email!"
        case .invalidEmailOrPassword:
            "Invalid email or password!"
        case .networkError:
            "Network connetion failed!"
        }
    }
}

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
        do {
            let authDataResult = try await createUser(withEmail: email, password: password)
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
            let authDataResult = try await signIn(withEmail: email, password: password)
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
            let authDataResult = try await signIn(with: credential)
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

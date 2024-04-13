//
//  GoogleSignInResultModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 13.12.23.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

final class SignInGoogleHelper {
    
    private var authenticationProvider: AuthenticationServiceProvidable
    
    init(authenticationProvider: AuthenticationServiceProvidable) {
        self.authenticationProvider = authenticationProvider
    }
    
    @MainActor
    func signIn() async throws -> GoogleSignInResultModel {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { throw "Cannot find windowScene" }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { throw "Cannot find rootViewController" }

        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        
        guard let idToken: String = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        
        let accessToken: String = gidSignInResult.user.accessToken.tokenString
        
        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken)
        let _ = try await authenticationProvider.signInWithGoogle(tokens: tokens)
        return tokens
    }
}

struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

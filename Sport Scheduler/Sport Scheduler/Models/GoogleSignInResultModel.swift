//
//  GoogleSignInResultModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 13.12.23.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
}

final class SignInGoogleHelper {
    
    private var authenticationProvider: AuthenticationServiceProvidable
    
    init(authenticationProvider: AuthenticationServiceProvidable) {
        self.authenticationProvider = authenticationProvider
    }
    
    @MainActor
    func signIn() async throws -> GoogleSignInResultModel {
        guard let topVC = Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken: String = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        
        let accessToken: String = gidSignInResult.user.accessToken.tokenString
        
        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken)
        let _ = try await authenticationProvider.signInWithGoogle(tokens: tokens)
        return tokens
    }
}

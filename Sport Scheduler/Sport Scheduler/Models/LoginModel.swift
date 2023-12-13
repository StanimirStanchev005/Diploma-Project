//
//  LoginModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 7.12.23.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

@MainActor
final class LoginModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    let error = "Invalid email or password"
    
    var isEmailValid: Bool {
        NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}+").evaluate(with: email)
    }
    
    var isPasswordValid: Bool {
        password.count >= 8
    }
    
    var isInputValid: Bool {
        isEmailValid && isPasswordValid
    }
    
    func login() async throws {
        guard isInputValid else { return }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
    }
}

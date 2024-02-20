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
import FirebaseFirestore

@MainActor
final class LoginModel: ObservableObject {
    private var authenticationProvider: AuthenticationServiceProvidable
    private var userRepository: UserRepository
    
    @Published var email = ""
    @Published var password = ""
    @Published var hasError = false
    @Published var localizedError: String = "There was an error signing in!"
    
    init(authenticationProvider: AuthenticationServiceProvidable = Auth.auth(),
         databaseProvider: UserRepository = Firestore.firestore()) {
        self.authenticationProvider = authenticationProvider
        self.userRepository = databaseProvider
    }
    
    var isEmailValid: Bool {
        NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}+").evaluate(with: email)
    }
    
    var isPasswordValid: Bool {
        password.count >= 8
    }
    
    var isInputValid: Bool {
        isEmailValid && isPasswordValid
    }
    
    func login() async throws -> DBUser {
        let authDataResult = try await authenticationProvider.signIn(email: email, password: password)
        return try await userRepository.getUser(userId: authDataResult.uid)
    }
    
    func signInGoogle() async throws -> DBUser {
        let helper = SignInGoogleHelper(authenticationProvider: authenticationProvider)
        let tokens = try await helper.signIn()
        let authDataResultModel = try await authenticationProvider.signInWithGoogle(tokens: tokens)
        let user: DBUser? = try await userRepository.getUser(userId: authDataResultModel.uid)
        if user == nil {
            let user = DBUser(userID: authDataResultModel.uid, name: authDataResultModel.name ?? "", email: authDataResultModel.email ?? "", photoUrl: authDataResultModel.photoUrl, dateCreated: Date())
            try userRepository.create(user: user)
            return user
        } else {
            return user!
        }
    }
}

extension LoginModel {
    
    func validEmail() -> Bool {
        if email.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            return false
        } else {
            return !isEmailValid
        }
    }
    
    func validPassword() -> Bool {
        if password.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            return false
        } else {
            return !isPasswordValid
        }
        
    }
}

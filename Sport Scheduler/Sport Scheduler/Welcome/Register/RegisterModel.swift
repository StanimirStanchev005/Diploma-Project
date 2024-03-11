//
//  RegisterModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 8.12.23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class RegisterModel: ObservableObject {
    private var authenticationProvider: AuthenticationServiceProvidable
    private var userRepository: UserRepository
    
    @Published var fullName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var hasError = false
    @Published var localizedError: String = "There was an error with signing up!"
    @Published var isTaskInProgress = false
    
    init(authenticationProvider: AuthenticationServiceProvidable = FirebaseAuthenticationProvider(), databaseProvider: UserRepository = FirestoreUserRepository()) {
        self.authenticationProvider = authenticationProvider
        self.userRepository = databaseProvider
    }
    
    var isFullNameValid: Bool {
        !fullName.isEmpty
    }
    
    var isEmailValid: Bool {
        NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}+").evaluate(with: email)
    }
    
    var isPasswordValid: Bool {
        password.count >= 8
    }
    
    var isInputValid: Bool {
        isFullNameValid && isEmailValid && isPasswordValid
    }
    
    func register() async throws -> DBUser {
        let authDataResultModel = try await authenticationProvider.signUp(email: email, password: password)
        let user = DBUser(userID: authDataResultModel.uid, name: fullName, email: authDataResultModel.email ?? "", photoUrl: authDataResultModel.photoUrl, dateCreated: Date())
        try userRepository.create(user: user)
        return user
    }
    
    func signInGoogle() async throws -> DBUser {
        let helper = SignInGoogleHelper(authenticationProvider: authenticationProvider)
        let tokens = try await helper.signIn()
        let authDataResultModel = try await authenticationProvider.signInWithGoogle(tokens: tokens)
        if try await userRepository.checkIfUserExists(userId: authDataResultModel.uid) {
            return try await userRepository.getUser(userId: authDataResultModel.uid)
        } else {
            let user = DBUser(userID: authDataResultModel.uid, name: authDataResultModel.name ?? "", email: authDataResultModel.email ?? "", photoUrl: authDataResultModel.photoUrl, dateCreated: Date())
            try userRepository.create(user: user)
            return user
        }
    }
}

extension RegisterModel {
    func validFullname() -> Bool {
        if fullName.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            return false
        } else {
            return !isFullNameValid
        }
    }
    
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

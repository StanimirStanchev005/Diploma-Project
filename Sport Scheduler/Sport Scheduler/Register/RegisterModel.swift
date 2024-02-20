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
    private var databaseProvider: UserRepository
    
    @Published var fullName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var hasError = false
    @Published var localizedError: String = "There was an error with signing up!"
    
    init(authenticationProvider: AuthenticationServiceProvidable = Auth.auth(), databaseProvider: UserRepository = Firestore.firestore()) {
        self.authenticationProvider = authenticationProvider
        self.databaseProvider = databaseProvider
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
        try databaseProvider.create(user: user)
        return user
    }
    
    func signInGoogle() async throws -> DBUser {
        let helper = SignInGoogleHelper(authenticationProvider: authenticationProvider)
        let tokens = try await helper.signIn()
        let authDataResultModel = try await authenticationProvider.signInWithGoogle(tokens: tokens)
        let user: DBUser? = try await databaseProvider.getUser(userId: authDataResultModel.uid)
        if user == nil {
            let user = DBUser(userID: authDataResultModel.uid, name: authDataResultModel.name ?? "", email: authDataResultModel.email ?? "", photoUrl: authDataResultModel.photoUrl, dateCreated: Date())
            try databaseProvider.create(user: user)
            return user
        } else {
            return user!
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

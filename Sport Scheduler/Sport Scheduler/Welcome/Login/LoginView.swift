//
//  LoginView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 7.12.23.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    @EnvironmentObject var currentUser: CurrentUser
    @StateObject private var loginModel = LoginModel()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.darkGreen]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 50) {
                Spacer()
                VStack(spacing: 15) {
                    VStack(spacing: 0) {
                        SigningTextField(input: $loginModel.email, text: "Email", isCapitalized: false, isSecure: false, isUserValid: loginModel.isEmailValid)
                            .keyboardType(.emailAddress)
                        TextErrorView(error: "Please enter a valid email!", showingError: loginModel.validEmail())
                    }
                    VStack(spacing: 0) {
                        SigningTextField(input: $loginModel.password, text: "Password", isCapitalized: false, isSecure: true, isUserValid: loginModel.isPasswordValid)
                        TextErrorView(error: "Must be 8 symbols or more", showingError: loginModel.validPassword())
                    }
                    
                    Button {
                        Task {
                            loginModel.isTaskInProgress = true
                            defer { loginModel.isTaskInProgress = false }
                            do {
                                currentUser.user = try await loginModel.login()
                                currentUser.showSignInView = false
                            } catch let error as AuthError {
                                loginModel.hasError = true
                                loginModel.localizedError = error.localizedDescription
                            }
                        }
                    } label: {
                        SignInButton(text: "Sign in", color: loginModel.isInputValid ? .blue : .gray)
                    }
                    .disabled(loginModel.isInputValid == false)
                    
                    Rectangle()
                        .stroke(Color(.lightBackground))
                        .frame(width: 200, height: 0.5)
                    
                    Button {
                        Task {
                            loginModel.isTaskInProgress = true
                            defer { loginModel.isTaskInProgress = false }
                            do {
                                currentUser.user = try await loginModel.signInGoogle()
                                currentUser.showSignInView = false
                            } catch let error as AuthError {
                                loginModel.hasError = true
                                loginModel.localizedError = error.localizedDescription
                            }
                        }
                    } label: {
                        GoogleButton()
                    }
                    
                    Spacer()
                }
                .frame(width: 350)
                .alert("Error", isPresented: $loginModel.hasError) {
                    Button("OK") {
                        loginModel.hasError = false
                    }
                } message: {
                    Text(loginModel.localizedError)
                }
                .navigationTitle("Sign in")
                .navigationBarTitleDisplayMode(.inline)
            }
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
            .frame(height: 450)
            
            if loginModel.isTaskInProgress {
                Color.black.opacity(0.2)
                    .ignoresSafeArea()
                ProgressView()
                    .controlSize(.large)
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoginView().environmentObject({ () -> CurrentUser in
            let envObj = CurrentUser()
            envObj.user = DBUser(userID: "123", name: "Spas", email: "spas@mail.bg", photoUrl: "", dateCreated: Date())
            return envObj
        }() )
    }
}

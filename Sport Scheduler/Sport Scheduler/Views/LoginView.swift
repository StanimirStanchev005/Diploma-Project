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
        VStack(spacing: 50) {
            Spacer()
            VStack(spacing: 30) {
                VStack(spacing: 0) {
                    LabeledTextField(input: $loginModel.email, text: "Email", isCapitalized: false, isSecure: false, isUserValid: loginModel.isEmailValid)
                        .keyboardType(.emailAddress)
                    TextErrorView(error: "Please enter a valid email!", showingError: loginModel.validEmail())
                }
                VStack(spacing: 0) {
                    LabeledTextField(input: $loginModel.password, text: "Password", isCapitalized: false, isSecure: true, isUserValid: loginModel.isPasswordValid)
                    TextErrorView(error: "Password length must be > 8", showingError: loginModel.validPassword())
                }
            }
            VStack(spacing: 15) {
                
                Button {
                    Task {
                        do {
                            currentUser.user = try await loginModel.login()
                            currentUser.showSignInView = false
                        } catch {
                            loginModel.hasError = true
                        }
                    }
                } label: {
                    SignInButton(text: "Sign in", color: loginModel.isInputValid ? .blue : .gray)
                }
                .disabled(loginModel.isInputValid == false)
                
                Rectangle()
                    .frame(maxWidth: 350, maxHeight: 2)
                
                Button {
                    Task {
                        do {
                            currentUser.user = try await loginModel.signInGoogle()
                            currentUser.showSignInView = false
                        } catch {
                            print("Error signing in with Google!")
                        }
                    }
                } label: {
                    GoogleButton()
                }
            }
            .alert("Invalid email or password!", isPresented: $loginModel.hasError) { }
            .navigationTitle("Sign in")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
#Preview {
    LoginView()
}

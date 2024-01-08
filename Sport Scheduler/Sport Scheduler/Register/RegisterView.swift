//
//  RegisterView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 7.12.23.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var currentUser: CurrentUser
    @StateObject private var registerModel = RegisterModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            VStack(spacing: 10) {
                VStack(spacing: 0) {
                    SigningTextField(input: $registerModel.fullName , text: "Full name", isCapitalized: true, isSecure: false, isUserValid: registerModel.isFullNameValid)
                    TextErrorView(error: "Enter your name!", showingError: registerModel.validFullname())
                }
                VStack(spacing: 0) {
                    SigningTextField(input: $registerModel.email , text: "Email", isCapitalized: false, isSecure: false, isUserValid: registerModel.isEmailValid)
                        .keyboardType(.emailAddress)
                    TextErrorView(error: "Please enter a valid email!", showingError: registerModel.validEmail())
                }
                VStack(spacing: 0) {
                    SigningTextField(input: $registerModel.password , text: "Password", isCapitalized: false, isSecure: true, isUserValid: registerModel.isPasswordValid)
                    TextErrorView(error: "Password length must be > 8", showingError: registerModel.validPassword())
                }
            }
            VStack(spacing: 10) {
                Button {
                    Task {
                        do {
                            currentUser.user = try await registerModel.register()
                            currentUser.showSignInView = false
                        } catch let error as AuthError {
                            registerModel.hasError = true
                            registerModel.localizedError = error.localizedDescription
                        }
                    }
                } label: {
                    SignInButton(text: "Sign up", color: registerModel.isInputValid ? .blue : .gray)
                }
                .disabled(registerModel.isInputValid == false)
                
                Rectangle()
                    .stroke(Color(.lightBackground))
                    .frame(width: 350, height: 1)
                    
                
                Button {
                    Task {
                        do {
                            currentUser.user = try await registerModel.signInGoogle()
                            currentUser.showSignInView = false
                        } catch let error as AuthError {
                            registerModel.hasError = true
                            registerModel.localizedError = error.localizedDescription
                        }
                    }
                } label: {
                    GoogleButton()
                }
            }
            .alert("Error", isPresented: $registerModel.hasError) {
                Button("OK") {
                    registerModel.hasError = false
                }
            } message: {
                Text(registerModel.localizedError)
            }
            .padding(.bottom)
        }
        .navigationTitle("Register")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    RegisterView()
}
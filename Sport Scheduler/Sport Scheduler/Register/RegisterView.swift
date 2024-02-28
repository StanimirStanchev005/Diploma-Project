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
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.darkGreen]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 15) {
                
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
                        TextErrorView(error: "Must be 8 symbols or more", showingError: registerModel.validPassword())
                    }
        
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
                        .frame(width: 200, height: 0.5)
                    
                    
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
                .frame(width: 350)
                .alert("Error", isPresented: $registerModel.hasError) {
                    Button("OK") {
                        registerModel.hasError = false
                    }
                } message: {
                    Text(registerModel.localizedError)
                }
                Spacer()
            }
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
            .frame(height: 450)
            .navigationTitle("Register")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        RegisterView().environmentObject({ () -> CurrentUser in
            let envObj = CurrentUser()
            envObj.user = DBUser(userID: "123", name: "Spas", email: "spas@mail.bg", photoUrl: "", dateCreated: Date())
            return envObj
        }() )
    }
}

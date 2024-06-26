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
        GeometryReader { geometry in
            ZStack {
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
                                    currentUser.state = .hasUser
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
                                    currentUser.state = .hasUser
                                } catch let error as AuthError {
                                    loginModel.hasError = true
                                    loginModel.localizedError = error.localizedDescription
                                }
                            }
                        } label: {
                            GoogleButton()
                        }
                        .buttonStyle(.plain)

                        Spacer()
                    }
                    .frame(width: geometry.size.width * 0.92)
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
                .shadow(color: .lightBackground, radius: 10)
                .frame(height: 450)

                if loginModel.isTaskInProgress {
                    ProgressView()
                        .controlSize(.large)
                }
            }
            .padding(.horizontal)
        }
        .padding(.top, 20)
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

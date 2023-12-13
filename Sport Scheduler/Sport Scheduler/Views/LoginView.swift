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
    @StateObject private var loginModel = LoginModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack(spacing: 50) {
            Spacer()
            VStack(spacing: 30) {
                LabeledTextField(input: $loginModel.email, text: "Email", isCapitalized: false, isSecure: false, isUserValid: true)
                    .keyboardType(.emailAddress)
                LabeledTextField(input: $loginModel.password, text: "Password", isCapitalized: false, isSecure: true, isUserValid: true)
            }
            VStack(spacing: 15) {
                
                Button {
                    Task {
                        do {
                            try await loginModel.login()
                            showSignInView = false
                        } catch {
                            print("Error signing in!")
                        }
                    }
                } label: {
                    SignInButton(text: "Sign in", color: .blue)
                }
                
                Rectangle()
                    .frame(maxWidth: 350, maxHeight: 2)
                
                GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                    Task {
                        do {
                            try await loginModel.signInGoogle()
                                showSignInView = false
                        } catch {
                            print(error)
                        }
                    }
                }
                .padding(.vertical)
            }
            .padding(.bottom)
            .navigationTitle("Sign in")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    LoginView(showSignInView: .constant(false))
}

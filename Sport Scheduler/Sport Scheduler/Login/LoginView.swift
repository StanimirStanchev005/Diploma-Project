//
//  LoginView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 7.12.23.
//

import SwiftUI

struct LoginView: View {
    @State private var loginModel = LoginModel()
    private var invalidInputMessage = "Invalid email or password"
    var body: some View {
        VStack(spacing: 50) {
            Spacer()
            VStack {
            LabeledTextField(input: $loginModel.email, text: "Email", error: invalidInputMessage, isCapitalized: false, isSecure: false, isUserValid: false)
            LabeledTextField(input: $loginModel.password, text: "Password", error: invalidInputMessage, isCapitalized: false, isSecure: true, isUserValid: false)
            }
            VStack(spacing: 15) {
                SignInButton(text: "Sign in", destination: UserClubsView(), color: .blue)
                Rectangle()
                    .frame(maxWidth: 350, maxHeight: 2)
                SignInButton(text: "Google", destination: UserClubsView(), color: .black)
            }
        }
        .navigationTitle("Sign in")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    LoginView()
}

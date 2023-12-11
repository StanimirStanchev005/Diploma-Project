//
//  RegisterView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 7.12.23.
//

import SwiftUI

struct RegisterView: View {
    @State private var registerModel = RegisterModel()
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            VStack(spacing: 10) {
                VStack(spacing: 0) {
                    LabeledTextField(input: $registerModel.fullName , text: "Full name", isCapitalized: true, isSecure: false, isUserValid: registerModel.isFullNameValid)
                    TextErrorView(error: "Enter your name!", showingError: registerModel.validFullname())
                }
                VStack(spacing: 0) {
                    LabeledTextField(input: $registerModel.email , text: "Email", isCapitalized: false, isSecure: false, isUserValid: registerModel.isEmailValid)
                        .keyboardType(.emailAddress)
                    TextErrorView(error: "Enter a valid email!", showingError: registerModel.validEmail())
                }
                VStack(spacing: 0) {
                    LabeledTextField(input: $registerModel.password , text: "Password", isCapitalized: false, isSecure: true, isUserValid: registerModel.isPasswordValid)
                    TextErrorView(error: "Password length must be > 8", showingError: registerModel.validPassword())
                }
            }
            VStack(spacing: 10) {
                Button {
                    viewModel.register(name: registerModel.fullName, email: registerModel.email, password: registerModel.password)
                } label: {
                    SignInButton(text: "Sign up", color: registerModel.isInputValid ? .blue : .gray)
                }
                .disabled(registerModel.isInputValid == false)
                
                Rectangle()
                    .frame(maxWidth: 350, maxHeight: 2)
                
                Button {
                    //                    isShwoingUserClubsScreen.toggle()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.white)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke()
                            }
                        HStack {
                            Image("Google icon")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 50)
                            Text("Sign up with Google")
                                .foregroundStyle(.black)
                                .font(.title3)
                        }
                    }
                    .frame(maxWidth: 280, maxHeight: 60)
                }
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

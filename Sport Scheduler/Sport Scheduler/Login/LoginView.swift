//
//  LoginView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 7.12.23.
//

import SwiftUI

struct LoginView: View {
    @State private var loginModel = LoginModel()
    @State private var isShwoingUserClubsScreen = false
    
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
                    isShwoingUserClubsScreen = true
                } label: {
                    SignInButton(text: "Sign in", color: .blue)
                }
        
                Rectangle()
                    .frame(maxWidth: 350, maxHeight: 2)
                
                Button {
                    isShwoingUserClubsScreen = true
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
                            Text("Sign in with Google")
                                .foregroundStyle(.black)
                                .font(.title3)
                        }
                    }
                    .frame(maxWidth:280, maxHeight: 60)
                }
            }
            .padding(.bottom)
            .navigationDestination(isPresented: $isShwoingUserClubsScreen) {
                UserClubsView()
            }
            .navigationTitle("Sign in")
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    LoginView()
}

//
//  WelcomeView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 11.12.23.
//

import SwiftUI
import Firebase

struct WelcomeView: View {
    
    var body: some View {
        NavigationStack {
            ZStack {
               
                VStack {
                    Spacer()
                    
                    Image("running")
                        .resizable()
                        .scaledToFit()
                        .shadow(color: .white, radius: 30)
                        .padding()
                    
                    Spacer()
                    
                    VStack {
                        NavigationLink {
                            LoginView()
                        } label: {
                            SignInButton(text: "Sign in", color: .blue)
                        }
                        NavigationLink {
                            RegisterView()
                        } label: {
                            SignInButton(text: "Register", color: .blue)
                        }
                    }
                    .frame(width: 360, height: 150)
                    .padding(.vertical)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .shadow(color: .lightBackground, radius: 10)
                    .padding(.bottom)
                }
                .navigationTitle("Sport Scheduler")
            }
        }
        .tint(.lightBackground)
    }
}

#Preview {
    WelcomeView()
}

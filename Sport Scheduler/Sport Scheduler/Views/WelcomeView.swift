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
            VStack {
                Spacer()
                
                NavigationLink {
                    LoginView()
                } label: {
                    SignInButton(text: "Sign in", color: .lightBackground)
                }
                NavigationLink {
                    RegisterView()
                } label: {
                    SignInButton(text: "Register", color: .lightBackground)
                }
            }
            .padding(.bottom)
            .navigationTitle("Sport Scheduler")
        }
    }
}

#Preview {
    WelcomeView()
}

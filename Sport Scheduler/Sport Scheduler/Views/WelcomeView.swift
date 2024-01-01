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
                    SignInButton(text: "Sign in", color: .black)
                }
                NavigationLink {
                    RegisterView()
                } label: {
                    SignInButton(text: "Register", color: .black)
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

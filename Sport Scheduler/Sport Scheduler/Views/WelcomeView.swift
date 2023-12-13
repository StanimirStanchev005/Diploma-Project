//
//  WelcomeView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 11.12.23.
//

import SwiftUI
import Firebase

struct WelcomeView: View {
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                NavigationLink {
                    LoginView(showSignInView: $showSignInView)
                } label: {
                    SignInButton(text: "Sign in", color: .black)
                }
                NavigationLink {
                    RegisterView(showSignInView: $showSignInView)
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
    WelcomeView(showSignInView: .constant(false))
}

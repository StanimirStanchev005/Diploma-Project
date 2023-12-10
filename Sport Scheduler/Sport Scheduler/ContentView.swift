//
//  ContentView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 7.12.23.
//

import SwiftUI

struct ContentView: View {
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
                    SignInButton(text: "Register", color: .green)
                }
            }
            .padding(.bottom)
            .navigationTitle("Sport Scheduler")
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}

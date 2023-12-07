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
                SignInButton(text: "Sign in", destination: LoginView(), color: .black)
                SignInButton(text: "Register", destination: RegisterView(), color: .black)
            }
            .navigationTitle("Sport Scheduler")
        }
    }
}

#Preview {
    ContentView()
}

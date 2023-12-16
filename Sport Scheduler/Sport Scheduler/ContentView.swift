//
//  ContentView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 7.12.23.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var showSignInView = false
    
    private var authenticationProvider: AuthenticationServiceProvidable
    
    init(authenticationProvider: AuthenticationServiceProvidable = Auth.auth()) {
        self.authenticationProvider = authenticationProvider
    }
    
    var body: some View {
        ZStack {
            if !showSignInView{
                MainView(showSignInView: $showSignInView)
            }
        }
        .onAppear() {
            let authUser = try? authenticationProvider.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            WelcomeView(showSignInView: $showSignInView)
        }
    }
}

#Preview {
    ContentView()
}

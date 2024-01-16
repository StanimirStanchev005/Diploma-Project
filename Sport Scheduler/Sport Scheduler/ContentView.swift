//
//  ContentView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 7.12.23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ContentView: View {
    @EnvironmentObject var currentUser: CurrentUser
    
    private var authenticationProvider: AuthenticationServiceProvidable
    private var userRepository: UserRepository
    @State private var isActive = false
    
    init(authenticationProvider: AuthenticationServiceProvidable = Auth.auth(), userRepository: UserRepository = Firestore.firestore()) {
        self.authenticationProvider = authenticationProvider
        self.userRepository = userRepository
    }
    
    var body: some View {
        if isActive {
            ZStack {
                if !currentUser.showSignInView {
                    MainView()
                }
            }
            .fullScreenCover(isPresented: $currentUser.showSignInView) {
                WelcomeView()
            }
        } else {
            SplashView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
                .task {
                    let authUser = try? authenticationProvider.getAuthenticatedUser()
                    guard authUser != nil else {
                        self.currentUser.showSignInView = true
                        return
                    }
                    self.currentUser.user = try? await userRepository.getUser(userId: authUser!.uid)
                    self.currentUser.showSignInView = false
                }
        }
    }
}

#Preview {
    ContentView()
}

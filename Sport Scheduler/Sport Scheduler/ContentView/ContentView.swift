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
    @StateObject var contentViewModel = ContentViewModel()
    
    
    var body: some View {
        Group {
            if contentViewModel.showSplashView {
                SplashView()
            } else if currentUser.showSignInView {
                WelcomeView()
            } else {
                MainView()
            }
        }
        
        .task {
            await contentViewModel.checkUser(currentUser: currentUser)
        }
    }
}

#Preview {
    ContentView()
}

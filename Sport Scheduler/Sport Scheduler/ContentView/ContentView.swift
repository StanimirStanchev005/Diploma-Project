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
        ZStack {
            if contentViewModel.showSplashView {
                LoadingView()
            } else if currentUser.showSignInView {
                withAnimation(.easeInOut) {
                    WelcomeView()
                }
            } else {
                withAnimation(.easeInOut) {
                    MainView()
                }
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

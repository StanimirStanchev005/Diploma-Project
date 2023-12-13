//
//  ContentView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 7.12.23.
//

import SwiftUI

struct ContentView: View {
    @State private var showSignInView = false
    
    var body: some View {
        ZStack {
            if !showSignInView{
                MainView(showSignInView: $showSignInView)
            }
        }
        .onAppear() {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
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

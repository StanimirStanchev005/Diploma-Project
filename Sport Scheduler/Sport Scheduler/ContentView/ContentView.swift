//
//  ContentView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 7.12.23.
//

import SwiftUI

struct ContentView: View {
    @Environment(CurrentUser.self) private var currentUser: CurrentUser
    @State var contentViewModel = ContentViewModel()
    
    
    var body: some View {
        ZStack {
            switch currentUser.state {
            case .loading:
                LoadingView()
            case .noUser:
                withAnimation(.easeInOut) {
                    WelcomeView()
                }
            case .hasUser:
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

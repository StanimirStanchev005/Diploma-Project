//
//  MainView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 10.12.23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            UserClubsView()
                .tabItem {
                    Label("Clubs", systemImage: "person.3.fill")
                }
            
            WorkoutsView()
                .tabItem {
                    Label("Workouts", systemImage: "figure.run.square.stack.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
        }
    }
}

#Preview {
    MainView()
}

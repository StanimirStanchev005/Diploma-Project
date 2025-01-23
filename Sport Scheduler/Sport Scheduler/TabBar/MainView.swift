//
//  MainView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 10.12.23.
//

import SwiftUI

final class MainViewModel {
    private var userRepository: UserRepository
    
    init(userRepository: UserRepository = FirestoreUserRepository()) {
        self.userRepository = userRepository
    }
    
    @MainActor func triggerListener(for user: CurrentUser) {
        Task {
            do {
                for try await result in try await userRepository.listenForUserChanges(for: user.user!.userID) {
                    user.updateUser(with: result)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}

struct MainView: View {
    @Environment(CurrentUser.self) private var currentUser: CurrentUser
    private let mainViewModel = MainViewModel()

    var body: some View {
        TabView {
            JoinedClubsView()
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
        .onAppear {
            UITabBar.appearance().backgroundColor = .tabBar
            mainViewModel.triggerListener(for: currentUser)
        }
    }
}

#Preview {
    MainView()
}

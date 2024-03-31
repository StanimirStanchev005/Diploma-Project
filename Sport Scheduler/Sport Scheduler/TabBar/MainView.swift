//
//  MainView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 10.12.23.
//

import SwiftUI

final class MainViewModel: ObservableObject {
    private var userRepository: UserRepository
    
    init(userRepository: UserRepository = FirestoreUserRepository()) {
        self.userRepository = userRepository
    }
    
    func triggerListener(for user: CurrentUser) {
        userRepository.listenForUserChanges(for: user.user!.userID) { [weak self] newUser in
            guard self != nil else {
                print("Unable to update user")
                return
            }
            user.updateUser(with: newUser)
        }
    }
}

struct MainView: View {
    @EnvironmentObject var currentUser: CurrentUser
    @StateObject var mainViewModel = MainViewModel()
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
            mainViewModel.triggerListener(for: currentUser)
        }
    }
}

#Preview {
    MainView()
}

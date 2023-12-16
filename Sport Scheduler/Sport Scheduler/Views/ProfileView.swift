//
//  ProfileView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 10.12.23.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var profileModel = ProfileModel()
    //@StateObject private var user: DBUser
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationStack {
            List {
                if let user = profileModel.user {
                    Text("UserID: \(user.userID)")
                }
            }
            .task {
                try? await profileModel.laodCurrentUser()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Sign Out") {
                        Task {
                            do {
                                try profileModel.signOut()
                                showSignInView = true
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
            }
            .navigationTitle(profileModel.user?.name ?? "Profile")
        }
        
    }
}

#Preview {
    NavigationStack {
        ProfileView(showSignInView: .constant(false))
    }
}

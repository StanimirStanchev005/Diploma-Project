//
//  ProfileView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 10.12.23.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var profileModel = ProfileModel()
    @EnvironmentObject var currentUser: CurrentUser
    
    var body: some View {
        NavigationStack {
            List {
                Text("UserID: \(currentUser.user!.userID)")
            }
            .navigationTitle(currentUser.user!.name)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Sign Out") {
                        Task {
                            do {
                                try profileModel.signOut()
                                currentUser.showSignInView = true
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
            }
        }
        
        
    }
    
}


#Preview {
    NavigationStack {
        ProfileView()
    }
}

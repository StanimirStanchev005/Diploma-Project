//
//  ProfileView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 10.12.23.
//

import SwiftUI


struct ProfileView: View {
    @StateObject private var profileModel = ProfileModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationStack {
            List {
                if let user = profileModel.user {
                    Text("UserID: \(user.uid)")
                }
            }
            .onAppear{
                try? profileModel.laodCurrentUser()
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
            .navigationTitle("Profile")
        }
        
    }
}

#Preview {
    NavigationStack {
        ProfileView(showSignInView: .constant(false))
    }
}

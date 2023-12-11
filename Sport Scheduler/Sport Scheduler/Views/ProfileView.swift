//
//  ProfileView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 10.12.23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Profile View")
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Sign Out") {
                        viewModel.signOut()
                    }
                }
            }
            .navigationTitle(viewModel.user!.name)
        }
    }
}

#Preview {
    ProfileView()
}

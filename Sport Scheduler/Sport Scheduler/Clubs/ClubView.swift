//
//  ClubView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 10.12.23.
//

import SwiftUI

struct ClubView: View {
    @EnvironmentObject var clubModel: ClubModel
    @EnvironmentObject var currentUser: CurrentUser
    
    let club: UserClubModel
    
    var body: some View {
        ZStack {
            switch clubModel.state {
            case .loading:
                VStack {
                    ProgressView()
                        .controlSize(.large)
                    Text("Loading...")
                }
            case .club:
                if clubModel.isUserOwner(userId: currentUser.user?.userID) {
                    OwnedClubView()
                } else if clubModel.isJoined(joinedClubs: currentUser.user?.joinedClubs) {
                    JoinedClubView()
                } else {
                    LockedClubView()
                }
            }
        }
        .task {
            do {
                try await clubModel.fetchData(for: club.name)
            } catch {
                print("Error fetching club: \(error)")
            }
        }
    }
}

#Preview {
    NavigationStack {
        ClubView(club: UserClubModel(name: "Sofia City breakers", picture: "ClubPlaceholder"))
    }
}

//
//  ClubView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 10.12.23.
//

import SwiftUI

struct ClubView: View {
    @StateObject private var clubModel = ClubModel()
    @EnvironmentObject var currentUser: CurrentUser
    
    let club: UserClubModel
    
    var body: some View {
        ZStack {
            if clubModel.club == nil {
                VStack {
                    ProgressView()
                        .controlSize(.large)
                    Text("Loading...")
                }
            } else if clubModel.club!.ownerId == currentUser.user!.userID {
                OwnedClubView(clubModel: clubModel)
            } else if currentUser.user!.joinedClubs.contains(where: { club in
                club.name == clubModel.club!.clubName })
            {
                JoinedClubView(clubModel: clubModel)
            } else {
                LockedClubView(clubModel: clubModel)
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

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
            switch clubModel.state {
            case .loading:
                VStack {
                    ProgressView()
                        .controlSize(.large)
                    Text("Loading...")
                }
            case .club(let club):
                if clubModel.isUserOwner(userId: currentUser.user?.userID) {
                    OwnedClubView(clubModel: clubModel)
                } else if clubModel.isJoined(joinedClubs: currentUser.user?.joinedClubs) {
                    JoinedClubView(clubModel: clubModel)
                } else {
                    LockedClubView(clubModel: clubModel)
                }
            }
//            if clubModel.club == nil {
//                
//            } else if clubModel.club!.ownerId == currentUser.user!.userID {
//                
//            } else if currentUser.user!.joinedClubs.contains(where: { club in
//                club.name == clubModel.club!.clubName })
//            {
//                
//            } else {
//                
//            }
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

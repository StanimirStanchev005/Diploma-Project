//
//  OwnedClubsView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 1.01.24.
//

import SwiftUI

final class OwnedClubsModel: ObservableObject {
    @Published var ownedClubs: [UserClubModel] = []
}

struct OwnedClubsView: View {
    @EnvironmentObject var currentUser: CurrentUser
    @StateObject var ownedClubsModel = OwnedClubsModel()
    
    var body: some View {
        VStack {
            ClubList(clubs: ownedClubsModel.ownedClubs)
        }
        .toolbar {
            NavigationLink(destination: CreateClubView()) {
                Image(systemName: "plus")
            }
        }
        .navigationTitle("Owned Clubs")
        .onAppear() {
            ownedClubsModel.ownedClubs = currentUser.user!.ownedClubs
        }
    }
}

#Preview {
    OwnedClubsView()
}

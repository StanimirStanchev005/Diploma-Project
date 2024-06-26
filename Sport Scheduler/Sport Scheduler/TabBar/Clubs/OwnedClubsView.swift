//
//  OwnedClubsView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 1.01.24.
//

import SwiftUI

struct OwnedClubsView: View {
    @EnvironmentObject var currentUser: CurrentUser
    @ObservedObject var ownedClubsModel: TabBarClubsModel
    
    var body: some View {
        VStack {
            if currentUser.user!.ownedClubs.isEmpty {
                VStack {
                    ContentUnavailableView("You don't own any clubs yet.", systemImage: "person.3.fill", description: Text("Clubs you own will appear here"))
                   
                    Spacer()
                }
            } else {
                ClubList(clubs: ownedClubsModel.ownedClubs)
            }
        }
        .toolbar {
            Button {
                ownedClubsModel.canUserCreateClub(clubs: currentUser.user?.ownedClubs.count)
            } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $ownedClubsModel.showCreateClubView) {
            ownedClubsModel.ownedClubs = ownedClubsModel.filterUserClubs(by: currentUser.user!.ownedClubs)
        } content: {
            CreateClubView()
        }
        .alert("Oops!", isPresented: $ownedClubsModel.showSubscribeAlert) {
            Button("OK") { }
        } message: {
            Text("You've reached the maximum number of clubs for your account type! Upgrade your account to create more clubs.")
        }
        .navigationTitle("Owned Clubs")
        .onAppear() {
            ownedClubsModel.ownedClubs = ownedClubsModel.filterUserClubs(by: currentUser.user!.ownedClubs)
            ownedClubsModel.checkSubscription(tier: currentUser.user?.subscriptionPlan.tier)
        }
    }
}

#Preview {
    NavigationStack {
        OwnedClubsView(ownedClubsModel: TabBarClubsModel()).environmentObject({ () -> CurrentUser in
        let envObj = CurrentUser()
        envObj.user = DBUser(userID: "123", name: "Spas", email: "spas@mail.bg", photoUrl: "", dateCreated: Date())
        return envObj
    }() )
}
}

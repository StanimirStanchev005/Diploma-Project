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
            if currentUser.user!.ownedClubs.isEmpty {
                VStack {
                    Text("You don't own any clubs yet.\nClubs you own will appear here")
                        .font(.title2)
                        .padding()
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            } else {
                ClubList(clubs: ownedClubsModel.ownedClubs)
            }
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
    NavigationStack {
    OwnedClubsView().environmentObject({ () -> CurrentUser in
        let envObj = CurrentUser()
        envObj.user = DBUser(userID: "123", name: "Spas", email: "spas@mail.bg", photoUrl: "", dateCreated: Date())
        return envObj
    }() )
}
}

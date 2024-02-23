//
//  JoinedClubsView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 1.01.24.
//

import SwiftUI

struct JoinedClubsView: View {
    @EnvironmentObject var currentUser: CurrentUser
    @StateObject var joinedClubsModel = JoinedClubsModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                if !joinedClubsModel.searchedClub.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    List {
                        ForEach(joinedClubsModel.filteredClubs, id: \.name.self) { club in
                            NavigationLink(destination: ClubView(club: club)) {
                                HStack {
                                    Image(club.picture)
                                        .resizable()
                                        .frame(width: 50)
                                        .clipShape(Circle())
                                        .frame(width: 50, height: 50)
                                    
                                    Text(club.name)
                                        .bold()
                                        .foregroundStyle(.lightBackground)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                } else {
                    VStack {
                        ClubList(clubs: currentUser.user!.joinedClubs)
                    }
                }
            }
            .toolbar {
                NavigationLink("Owned Clubs") {
                    OwnedClubsView()
                }
            }
            .navigationTitle("Joined Clubs")
            .searchable(text: $joinedClubsModel.searchedClub, placement: .navigationBarDrawer, prompt: Text("Search club to join..."))
            .autocorrectionDisabled(true)
        }
    }
}

#Preview {
    JoinedClubsView()
}

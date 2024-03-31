//
//  JoinedClubsView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 1.01.24.
//

import SwiftUI

struct JoinedClubsView: View {
    @EnvironmentObject var currentUser: CurrentUser
    @StateObject var joinedClubsModel = TabBarClubsModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                if !joinedClubsModel.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
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
                } else if currentUser.user!.joinedClubs.isEmpty {
                    VStack {
                        Text("You're not a member of any club yet. Clubs you're a member of will appear here.")
                            .font(.title2)
                            .padding()
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
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
            .searchable(text: $joinedClubsModel.searchQuery, placement: .navigationBarDrawer, prompt: Text("Search club to join..."))
            .autocorrectionDisabled(true)
            .onAppear {
                joinedClubsModel.triggerListener()
            }
        }
    }
}

#Preview {
    NavigationStack {
        JoinedClubsView().environmentObject({ () -> CurrentUser in
            let envObj = CurrentUser()
            envObj.user = DBUser(userID: "123", name: "Spas", email: "spas@mail.bg", photoUrl: "", dateCreated: Date())
            return envObj
        }() )
    }
}

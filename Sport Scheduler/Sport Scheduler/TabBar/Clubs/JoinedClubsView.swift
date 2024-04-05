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
                                    AsyncImage(url: URL(string: club.picture)) { image in
                                        image
                                            .resizable()
                                            .frame(width: 50)
                                            .clipShape(Circle())
                                            .frame(width: 50, height: 50)
                                    } placeholder: {
                                        Image("ClubPlaceholder")
                                            .resizable()
                                            .frame(width: 50)
                                            .clipShape(Circle())
                                            .frame(width: 50, height: 50)
                                    }
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
                        ContentUnavailableView("You're not a member of any club yet.", systemImage: "person.3.fill", description: Text("Clubs you're a member of will appear here."))
                        Spacer()
                    }
                } else {
                    VStack {
                        ClubList(clubs: joinedClubsModel.joinedClubs)
                    }
                }
            }
            .toolbar {
                NavigationLink("Owned Clubs") {
                    OwnedClubsView(ownedClubsModel: joinedClubsModel)
                }
            }
            .navigationTitle("Joined Clubs")
            .searchable(text: $joinedClubsModel.searchQuery, placement: .navigationBarDrawer, prompt: Text("Search club to join..."))
            .autocorrectionDisabled(true)
            .onAppear {
                joinedClubsModel.triggerListener()
            }
            .onChange(of: joinedClubsModel.mappedClubs.count) {
                joinedClubsModel.joinedClubs = joinedClubsModel.filterUserClubs(by: currentUser.user!.joinedClubs)
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

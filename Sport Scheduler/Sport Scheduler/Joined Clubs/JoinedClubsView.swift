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
            List {
                ForEach(joinedClubsModel.filteredClubs, id: \.name.self) { club in
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
            .scrollContentBackground(.hidden)
            
            VStack {
                List {
                    ForEach(currentUser.user!.joinedClubs, id: \.name.self) { club in
                        NavigationLink(destination: ClubView(club: club)) {
                            HStack {
                                Text(club.name)
                                    .bold()
                                    .foregroundStyle(.lightBackground)
                                
                                Spacer()
                                
                                Image(club.picture)
                                    .resizable()
                                    .frame(width: 100)
                                    .clipShape(Circle())
                                    .frame(width: 100, height: 100)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .toolbar {
                NavigationLink("Owned Clubs") {
                    OwnedClubsView()
                }
            }
            .navigationTitle("Joined Clubs")
            .searchable(text: $joinedClubsModel.searchedClub, placement: .navigationBarDrawer, prompt: Text("Search club to join..."))
        }
        
        .onChange(of: joinedClubsModel.searchedClub) {
            joinedClubsModel.applyFilterWithDebounce()
        }
        
        .onSubmit {
            joinedClubsModel.applyFilterWithDebounce()
        }
    }
}

#Preview {
    JoinedClubsView()
}

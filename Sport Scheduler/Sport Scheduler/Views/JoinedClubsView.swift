//
//  JoinedClubsView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 1.01.24.
//

import SwiftUI

struct JoinedClubsView: View {
    @EnvironmentObject var currentUser: CurrentUser
    @StateObject private var exampleUser = DBUser(userID: "123", name: "Spas", email: "spas@mail.bg", photoUrl: nil, dateCreated: Date())
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(currentUser.user!.joinedClubs) { club in
                        NavigationLink(value: club) {
                            HStack {
                                VStack {
                                    Text(club.name)
                                        .bold()
                                        .foregroundStyle(.black)
                                    Text("Members: \(club.members.count)")
                                        .foregroundStyle(.black)
                                }
                                
                                Image(club.picture)
                                    .resizable()
                                    .clipShape(.circle)
                                    .scaledToFit()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .navigationDestination(for: Club.self) {_ in
                            ClubView(club: club)
                        }
                    }
                    
                }
                Button("Add Clubs") {
                    exampleUser.joinedClubs.append(Club(name: "Joined Glub"))
                    exampleUser.joinedClubs.append(Club(name: "Sofia City Breakers"))
                    exampleUser.ownedClubs.append(Club(name: "Owned Gym"))
                    exampleUser.ownedClubs.append(Club(name: "Owned Tennis Club"))
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom)
            }
            .toolbar {
                NavigationLink("Owned Clubs") {
                    OwnedClubsView()
                }
            }
            .navigationTitle("Joined Clubs")
        }
    }
}


#Preview {
    JoinedClubsView()
}

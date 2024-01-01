//
//  OwnedClubsView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 1.01.24.
//

import SwiftUI

struct OwnedClubsView: View {
    @EnvironmentObject var currentUser: CurrentUser
    
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
            }
            .toolbar {
                Button {
                    
                } label: {
                    Image(systemName: "plus")
                }
            }
            .navigationTitle("Owned Clubs")
        }
    }
}

#Preview {
    OwnedClubsView()
}

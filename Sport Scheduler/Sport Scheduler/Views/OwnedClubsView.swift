//
//  OwnedClubsView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 1.01.24.
//

import SwiftUI

struct OwnedClubsView: View {
    @EnvironmentObject var currentUser: CurrentUser
    @State private var createClub = false
    
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
                    createClub.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $createClub) {
                CreateClubView()
                    .presentationDetents([.fraction(0.55)])
            }
            .navigationTitle("Owned Clubs")
        }
    }
}

#Preview {
    OwnedClubsView()
}

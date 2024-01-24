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
        VStack {
            List {
                ForEach(currentUser.user!.ownedClubs, id: \.name.self) { club in
                    NavigationLink(destination: ClubView(club: club)) {
                        HStack {
                            Text(club.name)
                                .bold()
                                .foregroundStyle(.black)
                            
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
            NavigationLink(destination: CreateClubView()) {
                Image(systemName: "plus")
            }
        }
        .navigationTitle("Owned Clubs")
    }
}

#Preview {
    OwnedClubsView()
}

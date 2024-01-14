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
                            VStack {
                                Text(club.name)
                                    .bold()
                                    .foregroundStyle(.black)
                            }
                            
                            Image(club.picture)
                                .resizable()
                                .clipShape(.circle)
                                .scaledToFit()
                        }
                    }
                    .frame(maxWidth: .infinity)
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

#Preview {
    OwnedClubsView()
}

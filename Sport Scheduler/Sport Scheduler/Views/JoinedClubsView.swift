//
//  JoinedClubsView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 1.01.24.
//

import SwiftUI

struct JoinedClubsView: View {
    @EnvironmentObject var currentUser: CurrentUser
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(currentUser.user!.joinedClubs, id: \.name.self) { club in
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

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

//
//  ClubList.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 20.02.24.
//

import SwiftUI

struct ClubList: View {
    var clubs: [UserClubModel]

    var body: some View {
        List {
            ForEach(clubs, id: \.name.self) { club in
                NavigationLink(destination: ClubView(club: club)) {
                    HStack {
                        Text(club.name)
                            .bold()
                            .foregroundStyle(.lightBackground)

                        Spacer()

                        AsyncImage(url: URL(string: club.picture)) { image in
                            image
                                .resizable()
                                .frame(width: 100)
                                .clipShape(Circle())
                                .frame(width: 100, height: 100)
                        } placeholder: {
                            if club.picture == "ClubPlaceholder" {
                                Image(systemName: "person.3.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.lightBackground)
                                    .frame(width: 80, height: 80)
                                    .frame(width: 100, height: 100)
                                    .padding()
                            } else {
                                    ProgressView()
                                        .frame(width: 100, height: 100)
                                }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
            }
        }
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    ClubList(clubs: [])
}

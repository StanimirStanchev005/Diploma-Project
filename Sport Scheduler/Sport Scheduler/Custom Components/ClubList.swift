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

                        ImageLoadingView(url: club.picture, club: club.name)
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

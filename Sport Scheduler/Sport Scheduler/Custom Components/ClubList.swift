//
//  ClubList.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 20.02.24.
//

import SwiftUI
import CachedAsyncImage

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

                        CachedAsyncImage(url: URL(string: club.picture)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .frame(width: 100)
                                    .clipShape(Circle())
                                    .frame(width: 100, height: 100)
                                    .padding()
                            case .failure(_):
                                Image(systemName: "person.3.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.lightBackground)
                                    .frame(width: 100, height: 100)
                                    .padding()
                            default:
                                ProgressView()
                                    .controlSize(.large)
                                    .frame(width: 100, height: 100)
                                    .padding()
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

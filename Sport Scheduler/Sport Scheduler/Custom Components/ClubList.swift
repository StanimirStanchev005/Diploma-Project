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
}

#Preview {
    ClubList(clubs: [])
}

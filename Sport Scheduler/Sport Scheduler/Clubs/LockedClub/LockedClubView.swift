//
//  LockedClubView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 13.02.24.
//

import SwiftUI

struct LockedClubView: View {
    @EnvironmentObject var currentUser: CurrentUser
    @StateObject var lockedClubModel = LockedClubModel()
    @StateObject var clubModel: ClubModel
    
    var body: some View {
        ZStack {
            if lockedClubModel.club == nil {
                ProgressView()
                    .controlSize(.large)
            } else {
                VStack(spacing: 10) {
                    Image(lockedClubModel.club!.picture)
                        .resizable()
                        .frame(width: 100)
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                        .padding()
                    
                    Text("Members: \(lockedClubModel.club!.members.count)")
                        .font(.headline)
                    
                    Text(lockedClubModel.club!.description)
                        .font(.title3)
                        .padding([.leading, .trailing], 15)
                    
                    Divider()
                    
                    Image(systemName: "lock")
                        .font(.system(size: 50))
                        .padding()
                    
                    Text("Join to see the club's workout schedule")
                        .multilineTextAlignment(.center)
                        .font(.title3)
                        .padding([.leading, .trailing], 30)
                    Spacer()
                }
                .toolbar {
                    Button {
                        // Add Action for applying to join club
                        
                        
                    } label: {
                        Text("Apply")
                    }
                }
                .navigationTitle(lockedClubModel.club!.clubName)
            }
        }
        .onAppear {
            lockedClubModel.club = clubModel.club
        }
//        .task {
//            do {
//                try await lockedClubModel.fetchData(for: club.name)
//            } catch {
//                print("Error fetching club: \(error)")
//            }
//        }
    }
}

#Preview {
    NavigationStack {
        LockedClubView(clubModel: ClubModel())
    }
}

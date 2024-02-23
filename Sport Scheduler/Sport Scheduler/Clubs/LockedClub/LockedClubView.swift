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
    @State private var isRequestSend = false

    var body: some View {
        VStack(spacing: 10) {
            ClubHeader(picture: clubModel.club!.picture, members: clubModel.club!.members.count, description: clubModel.club!.description)
            
            Divider()
            
            ContentUnavailableView("Club is locked", systemImage: "lock", description: Text("Join this club to see their workouts"))
            
            Spacer()
        }
        .toolbar {
            Button {
                do {
                    let request = ClubRequestModel(clubID: clubModel.club!.clubName, userID: currentUser.user!.userID, userName: currentUser.user!.name)
                    try lockedClubModel.sendJoinRequest(for: clubModel.club!.clubName, request: request)
                    currentUser.addRequest(requestID: request.requestID, clubID: clubModel.club!.clubName)
                    isRequestSend = true
                } catch {
                    print("Error while sending join request: \(error)")
                }
            } label: {
                Text("Apply")
            }
            .disabled(currentUser.user!.requests.contains(where: { request in
                request.clubID == clubModel.club!.clubName &&
                request.status == RequestStatus.pending.rawValue
            }))
        }
        
        .alert("Success", isPresented: $isRequestSend) {
            Button("OK") { }
        } message: {
            Text("Request to join was sent successfully")
        }
        .navigationTitle(clubModel.club!.clubName)
        .onAppear {
            lockedClubModel.club = clubModel.club
        }
    }
}

#Preview {
    NavigationStack {
        LockedClubView(clubModel: ClubModel())
    }
}

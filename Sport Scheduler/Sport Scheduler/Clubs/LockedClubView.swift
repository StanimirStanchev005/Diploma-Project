//
//  LockedClubView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 13.02.24.
//

import SwiftUI

struct LockedClubView: View {
    @EnvironmentObject var currentUser: CurrentUser
    @EnvironmentObject var clubModel: ClubModel
    @State private var isRequestSend = false

    var body: some View {
        VStack(spacing: 10) {
            ClubHeader(showButtons: false)
            
            ContentUnavailableView("Club is locked", systemImage: "lock", description: Text("Join this club to see their workouts"))
            
            Spacer()
        }
        .toolbar {
            Button {
                do {
                    let request = ClubRequestModel(clubID: clubModel.club!.clubName, userID: currentUser.user!.userID, userName: currentUser.user!.name)
                    try clubModel.sendJoinRequest(for: clubModel.club!.clubName, request: request)
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
    }
}

#Preview {
    let clubModel = ClubModel()
    clubModel.club = Club(clubName: "Levski", description: "xxxx", category: "Football", ownerId: "123")
    clubModel.club?.members.append(ClubUserModel(userID: "333", name: "Spas4o", visitedWorkouts: 3))
    let currentUser = CurrentUser()
    currentUser.user = DBUser(userID: "123", name: "Spas", email: "spas@mail.bg", photoUrl: "", dateCreated: Date())
    return LockedClubView().environmentObject(currentUser)
}

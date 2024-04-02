//
//  OwnedClubView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 15.02.24.
//

import SwiftUI

struct ClubContentView: View {
    @State private var showAddWorkoutScreen = false
    @State private var selectedDate = Date()
    @State private var isRequestSend = false
    @ObservedObject var clubModel: ClubModel
    @EnvironmentObject var currentUser: CurrentUser
    
    private var isOwner: Bool {
        clubModel.isUserOwner(userId: currentUser.user?.userID)
    }
    private var isJoined: Bool {
        clubModel.isJoined(joinedClubs: currentUser.user?.joinedClubs)
    }
    
    var navbarButtons: some View {
        Group {
            if isOwner {
                Button {
                    showAddWorkoutScreen.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            } else if !isJoined {
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
        }
    }
    
    var body: some View {
        VStack {
            ClubHeader(clubModel: clubModel, isOwner: isOwner, isJoined: isJoined)
            
            if isOwner || isJoined {
                if clubModel.isTaskInProgress {
                    ProgressView()
                        .controlSize(.large)
                } else {
                    WorkoutListView(clubModel: clubModel, isOwner: isOwner, isHistory: clubModel.isHistory)
                }
            } else {
                ContentUnavailableView("Club is locked", systemImage: "lock", description: Text("Join this club to see their workouts"))
            }
            Spacer()
        }
        .scrollContentBackground(.hidden)
        
        .alert("Success", isPresented: $isRequestSend) {
            Button("OK") { }
        } message: {
            Text("Request to join was sent successfully")
        }
        .sheet(isPresented: $showAddWorkoutScreen) {
            clubModel.fetchWorkouts()
        } content: {
            AddWorkoutView(clubID: clubModel.club!.clubName)
        }
        .navigationTitle(clubModel.club!.clubName)
        .toolbar {
            navbarButtons
        }
        .onAppear {
            clubModel.isHistory = false
            clubModel.clearWorkouts()
            clubModel.fetchWorkouts()
        }
    }
}

#Preview {
    Text("Preview is unavailable for now")
}

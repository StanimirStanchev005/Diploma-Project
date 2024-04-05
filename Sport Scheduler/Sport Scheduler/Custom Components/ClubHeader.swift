//
//  ClubHeader.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 18.02.24.
//

import SwiftUI
import PhotosUI

struct ClubHeader: View {
    @EnvironmentObject var currentUser: CurrentUser
    @ObservedObject var clubModel: ClubModel
    let isOwner: Bool
    let isJoined: Bool
    
    init(clubModel: ClubModel, isOwner: Bool = false, isJoined: Bool = false) {
        self.clubModel = clubModel
        self.isOwner = isOwner
        self.isJoined = isJoined
    }
    
    var body: some View {
        VStack(spacing: 10) {
            PhotosPicker(selection: $clubModel.selectedItem, matching: .images, photoLibrary: .shared()) {
                AsyncImage(url: URL(string: clubModel.club?.picture ?? "")) { image in
                    image
                        .resizable()
                        .frame(width: 100)
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                        .padding()
                } placeholder: {
                    Image("ClubPlaceholder")
                        .resizable()
                        .frame(width: 100)
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                        .padding()
                }
            }
            .disabled(!isOwner)
            
            HStack(spacing: 10) {
                Text("Members: \(clubModel.club?.members.count ?? 0)")
                    .font(.headline)
                if isJoined {
                    Text("My workouts: \(clubModel.visitedWorkouts(for: currentUser.user?.userID))")
                        .font(.headline)
                }
            }
            
            Text(clubModel.club?.description ?? "")
                .multilineTextAlignment(.center)
                .font(.title3)
                .padding([.leading, .trailing], 15)
                .lineLimit(2)
                .truncationMode(.tail)
            
            if isOwner {
                HStack(spacing: 10) {
                    NavigationLink("History", destination: WorkoutsHistoryView(clubModel: clubModel, isOwner: isOwner))
                        .foregroundStyle(.lightBackground)
                        .tint(.gray.opacity(0.2))
                        .buttonStyle(.borderedProminent)
                    NavigationLink("Requests (\(clubModel.userRequests.count))", destination: ClubRequestsView(clubModel: clubModel))
                        .foregroundStyle(.lightBackground)
                        .tint(.gray.opacity(0.2))
                        .buttonStyle(.borderedProminent)
                        .frame(maxWidth: 130)
                    NavigationLink("Members", destination: ClubMembersView(clubModel: clubModel))
                        .foregroundStyle(.lightBackground)
                        .tint(.gray.opacity(0.2))
                        .buttonStyle(.borderedProminent)
                    
                }
                .padding(10)
            } else if isJoined {
                NavigationLink("History", destination: WorkoutsHistoryView(clubModel: clubModel, isOwner: isOwner))
                    .foregroundStyle(.lightBackground)
                    .tint(.gray.opacity(0.2))
                    .buttonStyle(.borderedProminent)
            }
            Divider()
                .padding(.vertical, 10)
        }
    }
}

#Preview {
    let currentUser = CurrentUser()
    currentUser.user = DBUser(userID: "123", name: "spas", email: "spas@mail.bg", photoUrl: "", dateCreated: Date())
    return ClubHeader(clubModel: ClubModel(), isOwner: true)
        .environmentObject(currentUser)
}

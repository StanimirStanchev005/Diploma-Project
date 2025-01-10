//
//  ClubHeader.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 18.02.24.
//

import SwiftUI
import PhotosUI
@preconcurrency import CachedAsyncImage

struct ClubHeader: View {
    @Environment(CurrentUser.self) private var currentUser: CurrentUser
    @Binding var clubModel: ClubModel
    let isOwner: Bool
    let isJoined: Bool

    init(clubModel: Binding<ClubModel>, isOwner: Bool = false, isJoined: Bool = false) {
        self._clubModel = clubModel
        self.isOwner = isOwner
        self.isJoined = isJoined
    }
//    init(clubModel: ClubModel, isOwner: Bool = false, isJoined: Bool = false) {
//        self.clubModel = clubModel
//        self.isOwner = isOwner
//        self.isJoined = isJoined
//    }

    var cachedImage: some View {
        CachedAsyncImage(url: URL(string: clubModel.club?.data.picture ?? "")) { phase in
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

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                cachedImage
                PhotosPicker(selection: $clubModel.selectedItem, matching: .images, photoLibrary: .shared()) { Color.black.opacity(0) }
                    .disabled(!isOwner)
            }
            .frame(width: 100, height: 100)
                HStack(spacing: 10) {
                    Text("Members: \(clubModel.club?.data.members.count ?? 0)")
                        .font(.headline)
                    if isJoined {
                        Text("My workouts: \(clubModel.visitedWorkouts(for: currentUser.user?.userID))")
                            .font(.headline)
                    }
                }

            Text(clubModel.club?.data.description ?? "")
                    .multilineTextAlignment(.center)
                    .font(.title3)
                    .padding([.leading, .trailing], 15)
                    .lineLimit(2)
                    .truncationMode(.tail)

                if isOwner {
                    HStack(spacing: 10) {
                        NavigationLink("History", destination: WorkoutsHistoryView(clubModel: $clubModel, isOwner: isOwner))
                            .foregroundStyle(.lightBackground)
                            .tint(.gray.opacity(0.2))
                            .buttonStyle(.borderedProminent)
                        NavigationLink("Requests (\(clubModel.userRequests.count))", destination: ClubRequestsView(clubModel: $clubModel))
                            .foregroundStyle(.lightBackground)
                            .tint(.gray.opacity(0.2))
                            .buttonStyle(.borderedProminent)
                            .frame(maxWidth: 130)
                        NavigationLink("Members", destination: ClubMembersView(clubModel: $clubModel))
                            .foregroundStyle(.lightBackground)
                            .tint(.gray.opacity(0.2))
                            .buttonStyle(.borderedProminent)

                    }
                    .padding(10)
                } else if isJoined {
                    NavigationLink("History", destination: WorkoutsHistoryView(clubModel: $clubModel, isOwner: isOwner))
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
        let clubModel = ClubModel()
        clubModel.club = Club(clubName: "Levski", description: "Blue", category: "Football", ownerId: "1234")
        return ClubHeader(clubModel: .constant(clubModel), isOwner: true)
            .environment(currentUser)
    }

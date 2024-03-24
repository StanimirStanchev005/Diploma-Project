//
//  ClubModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 22.01.24.
//

import Foundation
import FirebaseFirestore

enum ClubScreenState {
    case loading
    case club(Club)
    // Add error state
}

final class ClubModel: ObservableObject {
    private var clubRepository: ClubRepository
    private var userRepository: UserRepository
    
    @Published var club: Club?
    @Published var workouts: [Workout] = []
    @Published var userRequests: [ClubRequestModel] = []
    @Published var isTaskInProgress = true
    @Published var state: ClubScreenState
    
    init(clubRepository: ClubRepository = FirestoreClubRepository(),
         userRepository: UserRepository = FirestoreUserRepository()) {
        self.clubRepository = clubRepository
        self.userRepository = userRepository
        
        state = .loading
    }
    
    func isUserOwner(userId: String?) -> Bool {
        guard let userId else {
            return false
        }
        return club?.ownerId == userId
    }
    
    func isJoined(joinedClubs: [UserClubModel]?) -> Bool {
        guard let joinedClubs else {
            return false
        }
        return joinedClubs.contains(where: { club in
            club.name == self.club?.clubName })
    }
    
    func triggerClubListeners() {
        clubRepository.listenForChanges(for: club!.id) { [weak self] club in
            guard let self = self else {
                print("Unable to update club")
                return
            }
            self.club = club
        }
    }
    
    func triggerRequestListeners() {
        clubRepository.listenForRequestChanges(for: club!.clubName) { [weak self] requests in
            guard let self = self else {
                print("Unable to update userRequests")
                return
            }
            self.userRequests = requests
        }
    }
    
    func fetchData(for clubID: String) async throws {
        let fetchedClub = try await clubRepository.getClub(clubId: clubID)
        Task {
            await MainActor.run {
                self.club = fetchedClub
                self.state = .club(fetchedClub)
                triggerClubListeners()
                triggerRequestListeners()
            }
        }
    }
    
    func fetchWorkouts(for clubId: String, on date: Date) async throws {
        let fetchedWorkouts = try await clubRepository.getWorkouts(for: clubId, on: date)
        
        Task {
            await MainActor.run {
                self.workouts = fetchedWorkouts
                isTaskInProgress = false
                print(workouts.count)
            }
        }
    }
    
    func deleteWorkout(at offsets: IndexSet) {
        let deletedWorkouts = offsets.map { workouts[$0] }
        
        for deletedWorkout in deletedWorkouts {
            do {
                try clubRepository.deleteWorkout(for: self.club!.clubName, with: deletedWorkout.workoutId)
            } catch {
                print("Error deleting workout: \(error)")
            }
        }
    }
        
    func removeMember(at offsets: IndexSet) {
        let membersToRemove = offsets.map { club!.members[$0] }
        
        for member in membersToRemove {
            do {
                try clubRepository.remove(user: member, from: self.club!)
            } catch {
                print("Error removing user from club: \(error)")
            }
        }
    }
    
    func sendJoinRequest(for clubId: String, request: ClubRequestModel) throws {
        try clubRepository.sendJoinRequest(for: clubId, from: request.userID, with: request.userName)
    }

    func accept(request: ClubRequestModel) throws {
        try clubRepository.accept(request: request, from: club!)
        let index = userRequests.firstIndex(where: {newRequest in newRequest.requestID == request.requestID})!
        userRequests[index].status = RequestStatus.accepted.rawValue
        userRequests.remove(at: index)
    }
    
    func reject(request: ClubRequestModel) throws {
        try clubRepository.reject(request: request, from: club!)
        let index = userRequests.firstIndex(where: {newRequest in newRequest.requestID == request.requestID})!
        userRequests.remove(at: index)
    }
}

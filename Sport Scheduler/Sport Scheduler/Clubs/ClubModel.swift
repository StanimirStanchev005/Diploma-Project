//
//  ClubModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 22.01.24.
//

import Foundation
import FirebaseFirestore

final class ClubModel: ObservableObject {
    private var clubRepository: ClubRepository
    private var userRepository: UserRepository
    
    @Published var club: Club?
    @Published var workouts: [Workout] = []
    @Published var userRequests: [ClubRequestModel] = []
    
    init(clubRepository: ClubRepository = FirestoreClubRepository(),
         userRepository: UserRepository = FirestoreUserRepository()) {
        self.clubRepository = clubRepository
        self.userRepository = userRepository
    }
    
    func triggerListeners() {
        clubRepository.listenForRequestChanges(for: club!.clubName) { [weak self] requests in
            guard let self = self else {
                print("Unable to update userRequests")
                return
            }
            self.userRequests = requests
        }
    }
    
    func fetchData(for clubId: String) async throws {
        let fetchedClub = try await clubRepository.getClub(clubId: clubId)
        
        Task {
            await MainActor.run {
                self.club = fetchedClub
            }
        }
    }
    
    func fetchWorkouts(for clubId: String, on date: Date) async throws {
        let fetchedWorkouts = try await clubRepository.getWorkouts(for: clubId, on: date)
        
        Task {
            await MainActor.run {
                self.workouts = fetchedWorkouts
            }
        }
    }
    
    func deletedWorkout(at offsets: IndexSet)  {
        let deletedWorkouts = offsets.map { workouts[$0] }
        
        for deletedWorkout in deletedWorkouts {
            do {
                try clubRepository.deleteWorkout(for: self.club!.clubName, with: deletedWorkout.workoutId)
            } catch {
                print("Error deleting workout: \(error)")
            }
        }
    }
    
    func getRequests() async throws {
        let requests = try await clubRepository.getRequests(for: club!.clubName)
        await MainActor.run {
            self.userRequests = requests
        }
    }
    
    func accept(request: ClubRequestModel) throws {
        try clubRepository.accept(request: request, from: club!)
        let index = userRequests.firstIndex(where: {newRequest in newRequest.requestID == request.requestID})!
        userRequests[index].status = RequestStatus.accepted.rawValue
    }
    
    func reject(request: ClubRequestModel) throws {
        try clubRepository.reject(request: request, from: club!)
        let index = userRequests.firstIndex(where: {newRequest in newRequest.requestID == request.requestID})!
        userRequests.remove(at: index)
    }
}

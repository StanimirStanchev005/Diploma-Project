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
    
    init(clubRepository: ClubRepository = Firestore.firestore(),
         userRepository: UserRepository = Firestore.firestore()) {
        self.clubRepository = clubRepository
        self.userRepository = userRepository
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
    }
}

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
    
    func fetchWorkouts(for clubId:String, on date: Date) async throws {
        let fetchedWorkouts = try await clubRepository.getWorkouts(for: clubId, on: date)
        
        Task {
            await MainActor.run {
                self.workouts = fetchedWorkouts
            }
        }
    }
}

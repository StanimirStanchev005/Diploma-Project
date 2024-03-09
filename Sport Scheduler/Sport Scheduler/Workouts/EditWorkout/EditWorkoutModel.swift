//
//  EditWorkoutModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 24.01.24.
//

import Foundation
import FirebaseFirestore

final class EditWorkoutModel: ObservableObject {
    
    private var clubRepository: ClubRepository
    
    init(clubRepository: ClubRepository = FirestoreClubRepository()) {
        self.clubRepository = clubRepository
    }
    
    func updateWorkout(for clubId: String, with workout: Workout) throws {
        do {
            try clubRepository.updateWorkout(for: clubId, with: workout)
        } catch {
            throw error
        }
    }
}

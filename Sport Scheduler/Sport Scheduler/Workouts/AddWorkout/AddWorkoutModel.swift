//
//  AddWorkoutModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 22.01.24.
//

import Foundation
import FirebaseFirestore

final class AddWorkoutModel: ObservableObject {
    @Published var workoutDate = Date()
    @Published var workoutTitle = ""
    @Published var workoutDescription = ""
    @Published var isRepeating = false
    
    private var clubRepository: ClubRepository
    
    var isValidInput: Bool {
        workoutTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    init(clubRepository: ClubRepository = FirestoreClubRepository()) {
        self.clubRepository = clubRepository
    }
    
    func save(for club: String, title: String, description: String, date: Date) throws {
        if isRepeating {
            try saveWorkouts(for: club, title: title, description: description, date: date)
        } else {
            try saveWorkout(for: club, title: title, description: description, date: date)
        }
    }
    
    func saveWorkout(for club: String, title: String, description: String, date: Date) throws {
        try clubRepository.add(workout: Workout(clubId: club, title: title, description: description, date: date), for: club)
    }
    
    func saveWorkouts(for club: String, title: String, description: String, date: Date) throws {
        let endDate = Calendar.current.date(byAdding: .day, value: 27, to: date)!
        var currentDate = date
        
        for _ in 1...4 {
            try saveWorkout(for: club, title: title, description: description, date: currentDate)
            
            currentDate = Calendar.current.date(byAdding: .day, value: 7, to: currentDate)!
            
            if currentDate > endDate {
                break
            }
        }
    }
}

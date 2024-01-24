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
    
    init(clubRepository: ClubRepository = Firestore.firestore()) {
        self.clubRepository = clubRepository
    }
    
    func save(for club: String, title: String, description: String, date: Date, isRepeating: Bool) throws {
        if isRepeating {
            try saveWorkouts(for: club, title: title, description: description, date: date, isRepeating: isRepeating)
        } else {
            try saveWorkout(for: club, title: title, description: description, date: date, isRepeating: isRepeating)
        }
    }
    
    func saveWorkout(for club: String, title: String, description: String, date: Date, isRepeating: Bool) throws {
        try clubRepository.addWorkout(for: club, workout: Workout(title: title, description: description, date: date, isRepeating: isRepeating))
    }
    
    func saveWorkouts(for club: String, title: String, description: String, date: Date, isRepeating: Bool) throws {
        let endDate = Calendar.current.date(byAdding: .day, value: 27, to: date)!
        var currentDate = date
        
        for _ in 1...4 {
            try saveWorkout(for: club, title: title, description: description, date: currentDate, isRepeating: isRepeating)

            currentDate = Calendar.current.date(byAdding: .day, value: 7, to: currentDate)!
    
            if currentDate > endDate {
                break
            }
        }
    }
}

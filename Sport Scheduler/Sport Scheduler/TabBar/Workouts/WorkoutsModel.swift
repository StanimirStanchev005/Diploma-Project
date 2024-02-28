//
//  WorkoutsModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 23.02.24.
//

import FirebaseFirestore

final class WorkoutsModel: ObservableObject {
    private var clubRepository: ClubRepository
    @Published var workouts: [UserWorkout] = []
    @Published var selectedDate = Date()
    
    init(clubRepository: ClubRepository = Firestore.firestore()) {
        self.clubRepository = clubRepository
    }
    
    func fetchWokrouts(for user: DBUser, on date: Date) {
        Task {
            do {
                let fetchedWorkouts = try await clubRepository.getAllWokrouts(for: user, on: date)
                await MainActor.run {
                    var userWorkouts: [UserWorkout] = []
                    for workout in fetchedWorkouts {
                        userWorkouts.append(UserWorkout(workoutId: workout.workoutId, club: workout.clubId, title: workout.title, description: workout.description, date: workout.date))
                    }
                    self.workouts = userWorkouts
                    workouts.sort { $0.date < $1.date }
                }
            } catch {
                print("Error fetching clubs: \(error)")
            }
        }
    }
}

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
    @Published var isTaskInProgress = true
    
    init(clubRepository: ClubRepository = FirestoreClubRepository()) {
        self.clubRepository = clubRepository
    }
    
    func fetchWokrouts(for user: DBUser) {
        Task {
            do {
                let fetchedWorkouts = try await clubRepository.getAllWokrouts(for: user, on: selectedDate)
                await MainActor.run {
                    var userWorkouts: [UserWorkout] = []
                    for workout in fetchedWorkouts {
                        userWorkouts.append(UserWorkout(workoutId: workout.workoutId, club: workout.clubId, title: workout.title, description: workout.description, date: workout.date))
                    }
                    self.workouts = userWorkouts
                    workouts.sort { $0.date < $1.date }
                    isTaskInProgress = false
                }
            } catch {
                print("Error fetching clubs: \(error)")
                isTaskInProgress = false
            }
        }
    }
}

//
//  WorkoutsView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 10.12.23.
//

import SwiftUI

import FirebaseFirestore

final class WorkoutsModel: ObservableObject {
    private var clubRepository: ClubRepository
    @Published var workouts: [UserWorkout] = []
    @State var selectedDate = Date()
    
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
                        userWorkouts.append(UserWorkout(workoutId: workout.workoutId, club: workout.clubId, tilte: workout.title, description: workout.description, date: workout.date))
                    }
                    self.workouts = userWorkouts
                }
            } catch {
                print("Error fetching clubs: \(error)")
            }
        }
    }
}

struct UserWorkout {
    let workoutId: String
    let club: String
    let tilte: String
    let description: String
    let date: Date
}

struct WorkoutsView: View {
    @EnvironmentObject var currentUser: CurrentUser
    @StateObject var workoutsModel = WorkoutsModel()
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(workoutsModel.workouts, id: \.workoutId.self) { workout in
                    HStack {
                        VStack {
                            Text(workout.tilte)
                            Text(workout.club)
                            Text(workout.date.formatted(date: .omitted, time: .shortened))
                            Text(workout.description)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Workouts")
        }
        .task {
            workoutsModel.fetchWokrouts(for: currentUser.user!, on: workoutsModel.selectedDate)
        }
        .onChange(of: workoutsModel.selectedDate) {
            workoutsModel.fetchWokrouts(for: currentUser.user!, on: workoutsModel.selectedDate)
        }
        
    }
}

#Preview {
    WorkoutsView()
}

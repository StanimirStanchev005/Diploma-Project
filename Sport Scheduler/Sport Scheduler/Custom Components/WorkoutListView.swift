//
//  WorkoutListView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 1.04.24.
//

import SwiftUI

struct WorkoutListView: View {
    @ObservedObject var clubModel: ClubModel
    var isOwner: Bool
    var isHistory: Bool
    var noWorkoutsMessage: String
    var key: String

    var body: some View {
        List {
            if clubModel.clubWorkouts[key]!.workouts.isEmpty && !clubModel.isTaskInProgress {
                ContentUnavailableView(noWorkoutsMessage, systemImage: "figure.core.training")
            }
            ForEach(clubModel.clubWorkouts[key]!.workoutDates, id:\.self) { date in
                Section {
                    ForEach(clubModel.filteredWorkouts(on: date, for: key), id:\.self.workoutId) { workout in
                        NavigationLink(destination: WorkoutView(workout: workout, clubModel: clubModel)) {
                            WorkoutRow(title: workout.title, description: workout.description, participants: workout.participants, date: workout.date)
                        }
                        .swipeActions(edge: .leading) {
                            if isOwner && !isHistory {
                                NavigationLink(destination: EditWorkoutView(workout: workout, clubID: clubModel.club!.clubName)) {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.indigo)
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            if isOwner && !isHistory {
                                Button(role: .destructive) {
                                    clubModel.deleteWorkout(id: workout.workoutId)
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                            }
                        }
                        if date == clubModel.clubWorkouts[key]!.workoutDates.last {
                            if workout == clubModel.filteredWorkouts(on: date, for: key).last {
                                HStack {
                                    Spacer()
                                    Text("You've reached the last planned workout")
                                        .font(.subheadline)
                                    Spacer()
                                }
                                .onAppear {
                                    clubModel.fetchWorkouts(for: key)
                                }
                            }
                        }
                    }
                } header: {
                    Text(date.formatted(date: .complete, time: .omitted))
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    WorkoutListView(clubModel: ClubModel(), isOwner: false, isHistory: false, noWorkoutsMessage: "", key: "current")
}

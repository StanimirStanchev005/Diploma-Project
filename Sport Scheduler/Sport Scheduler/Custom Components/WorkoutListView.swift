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
    
    var body: some View {
        List {
            if clubModel.workouts.isEmpty && !clubModel.isTaskInProgress {
                Text("There are no upcomming workouts")
                    .font(.title3)
            }
            ForEach(clubModel.workoutDates, id:\.self) { date in
                Section {
                    ForEach(clubModel.filteredWorkouts(for: date), id:\.self.workoutId) { workout in
                        NavigationLink(destination: WorkoutView(workout: workout, clubModel: clubModel)) {
                            WorkoutRow(title: workout.title, description: workout.description, participants: workout.participants, date: workout.date)
                        }
                        .swipeActions(edge: .leading) {
                            if isOwner {
                                NavigationLink(destination: EditWorkoutView(workout: workout, clubID: clubModel.club!.clubName)) {
                                    Label("Edit", systemImage: "pencil")
                                }
                            }
                        }
                        if date == clubModel.workoutDates.last {
                            if workout == clubModel.filteredWorkouts(for: date).last {
                                HStack {
                                    Spacer()
                                    Text("You've reached the last planned workout")
                                        .font(.subheadline)
                                    Spacer()
                                }
                                .onAppear {
                                    clubModel.fetchWorkouts()
                                }
                            }
                        }
                    }
                    .onDelete(perform: clubModel.deleteWorkout)
                    .deleteDisabled(!isOwner)
                } header: {
                    Text(date.formatted(date: .complete, time: .omitted))
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    WorkoutListView(clubModel: ClubModel(), isOwner: false, isHistory: false)
}

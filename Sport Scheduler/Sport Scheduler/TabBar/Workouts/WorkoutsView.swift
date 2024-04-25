//
//  WorkoutsView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 10.12.23.
//

import SwiftUI

struct WorkoutsView: View {
    @EnvironmentObject var currentUser: CurrentUser
    @StateObject var workoutsModel = WorkoutsModel()

    var body: some View {
        NavigationStack {
            VStack {
                if currentUser.user!.joinedClubs.isEmpty {
                    VStack {
                        Spacer()
                        ContentUnavailableView("Join a Club", systemImage: "figure.strengthtraining.traditional", description: Text("Joined club workouts will appear here"))
                        Spacer()
                    }
                } else {
                    ScrollView(.horizontal) {
                        Picker("Club", selection: $workoutsModel.selectedClub) {
                            ForEach(currentUser.user?.joinedClubs ?? [], id:\.self) { club in
                                Text(club)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                        .pickerStyle(.segmented)
                    }
                    List {
                        if workoutsModel.isTaskInProgress {

                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                                    .controlSize(.large)

                            }

                        } else if workoutsModel.clubWorkouts[workoutsModel.selectedClub]!.workouts.isEmpty && !workoutsModel.isTaskInProgress {
                            ContentUnavailableView("No upcomming workouts", systemImage: "sofa", description: Text("Feel free to relax"))
                        } else {
                            ForEach(workoutsModel.clubWorkouts[workoutsModel.selectedClub]!.workoutDates, id:\.self) { date in
                                Section {
                                    ForEach(workoutsModel.filteredWorkouts(on: date), id:\.self.workoutId) { workout in
                                        WorkoutRow(title: workout.title, description: workout.description, participants: workout.participants, date: workout.date)

                                        if date == workoutsModel.clubWorkouts[workoutsModel.selectedClub]!.workoutDates.last {
                                            if workout == workoutsModel.filteredWorkouts(on: date).last {
                                                HStack {
                                                    Spacer()
                                                    Text("You've reached the last planned workout")
                                                        .font(.subheadline)
                                                    Spacer()
                                                }
                                                .onAppear {
                                                    workoutsModel.fetchWorkouts(for: currentUser.user)
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
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Workouts")
        }
        .onAppear {
            guard let first = currentUser.user?.joinedClubs.first else {
                return
            }
            workoutsModel.selectedClub = first
            workoutsModel.setupClubWorkouts(with: currentUser.user?.joinedClubs)
            workoutsModel.fetchWorkouts(for: currentUser.user)
        }
        .onChange(of: workoutsModel.selectedClub) {
            workoutsModel.fetchWorkouts(for: currentUser.user)
        }
    }
}

#Preview {
    NavigationStack {
        WorkoutsView().environmentObject({ () -> CurrentUser in
            let envObj = CurrentUser()
            envObj.user = DBUser(userID: "123", name: "Spas", email: "spas@mail.bg", photoUrl: "", dateCreated: Date())
            envObj.user!.joinedClubs.append("Levski")
            return envObj
        }() )
    }
}

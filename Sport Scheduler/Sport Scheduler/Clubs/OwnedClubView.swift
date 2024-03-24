//
//  OwnedClubView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 15.02.24.
//

import SwiftUI

struct OwnedClubView: View {
    @State private var showAddWorkoutScreen = false
    @State private var selectedDate = Date()
    @EnvironmentObject var clubModel: ClubModel
    @EnvironmentObject var currentUser: CurrentUser
    
    var body: some View {
        VStack {
            ClubHeader(showButtons: true, selectedDate: $selectedDate)
            
            if clubModel.isTaskInProgress {
                ProgressView()
                    .controlSize(.large)
            } else if clubModel.workouts.isEmpty && !clubModel.isTaskInProgress {
                Spacer()
                Text("No workouts for the selected date.")
                    .font(.title3)
                Spacer()
            } else {
                List {
                    ForEach(clubModel.workouts, id:\.workoutId) { workout in
                        NavigationLink(destination: WorkoutView(workout: workout)) {
                            WorkoutRow(title: workout.title, description: workout.description, participants: workout.participants, date: workout.date)
                        }
                        .swipeActions(edge: .leading) {
                            NavigationLink(destination: EditWorkoutView(workout: workout, clubID: clubModel.club!.clubName)) {
                                Label("Edit", systemImage: "pencil")
                            }
                        }
                    }
                    .onDelete(perform: clubModel.deletedWorkout)
                }
            }
            Spacer()
        }
        .scrollContentBackground(.hidden)
        
        .sheet(isPresented: $showAddWorkoutScreen) {
            Task {
                do {
                    try await clubModel.fetchWorkouts(for: clubModel.club!.clubName, on: selectedDate)
                } catch {
                    print("Error fetching club's workouts: \(error)")
                }
            }
        } content: {
            AddWorkoutView(clubID: clubModel.club!.clubName)
        }
        .navigationTitle(clubModel.club!.clubName)
        .toolbar {
            Button {
                showAddWorkoutScreen.toggle()
            } label: {
                Image(systemName: "plus")
            }
        }
        .task {
            do {
                try await clubModel.fetchWorkouts(for: clubModel.club!.clubName, on: selectedDate)
            } catch {
                print("Error fetching club's workouts: \(error)")
            }
        }
        .onChange(of: selectedDate) {
            Task {
                try await clubModel.fetchWorkouts(for: clubModel.club!.clubName, on: selectedDate)
            }
        }
    }
}

#Preview {
    let clubModel = ClubModel()
    clubModel.club = Club(clubName: "Levski", description: "xxxx", category: "Football", ownerId: "123")
    clubModel.club?.members.append(ClubUserModel(userID: "333", name: "Spas4o", visitedWorkouts: 3))
    let currentUser = CurrentUser()
    currentUser.user = DBUser(userID: "123", name: "Spas", email: "spas@mail.bg", photoUrl: "", dateCreated: Date())
    return OwnedClubView().environmentObject(currentUser)
}

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
    @StateObject var clubModel: ClubModel
    @EnvironmentObject var currentUser: CurrentUser

    var body: some View {
        VStack(spacing: 10) {
            Image(clubModel.club!.picture)
                .resizable()
                .frame(width: 100)
                .clipShape(Circle())
                .frame(width: 100, height: 100)
                .padding()
            
            Text("Members: \(clubModel.club!.members.count)")
                .font(.headline)
            
            Text(clubModel.club!.description)
                .font(.title3)
                .padding([.leading, .trailing], 15)
            
            Divider()
            
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                .labelsHidden()
            
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
    OwnedClubView(clubModel: ClubModel())
}

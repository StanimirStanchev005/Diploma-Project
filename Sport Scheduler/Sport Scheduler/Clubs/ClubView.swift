//
//  ClubView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 10.12.23.
//

import SwiftUI

struct ClubView: View {
    @State private var showAddWorkoutScreen = false
    @State private var selectedDate = Date()
    @StateObject private var clubModel = ClubModel()
    @EnvironmentObject var currentUser: CurrentUser
    
    let club: UserClubModel
    
    var body: some View {
        ZStack {
            if clubModel.club == nil {
                ProgressView()
                    .controlSize(.large)
            } else {
                
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
                                NavigationLink(destination: EditWorkoutView(workout: workout, clubID: club.name)) {
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
                            try await clubModel.fetchWorkouts(for: club.name, on: selectedDate)
                        } catch {
                            print("Error fetching club's workouts: \(error)")
                        }
                    }
                } content: {
                    AddWorkoutView(clubID: club.name)
                }
                .navigationTitle(clubModel.club!.clubName)
                .toolbar {
                    Button {
                        showAddWorkoutScreen.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .task {
            do {
                try await clubModel.fetchData(for: club.name)
                try await clubModel.fetchWorkouts(for: club.name, on: selectedDate)
            } catch {
                print("Error fetching club's workouts: \(error)")
            }
        }
        .onChange(of: selectedDate) {
            Task {
                try await clubModel.fetchWorkouts(for: club.name, on: selectedDate)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ClubView(club: UserClubModel(name: "Sofia City breakers", picture: "ClubPlaceholder"))
    }
}

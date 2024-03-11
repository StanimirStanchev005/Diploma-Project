//
//  JoinedClubView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 22.02.24.
//

import SwiftUI

struct JoinedClubView: View {
    @State private var selectedDate = Date()
    @StateObject var clubModel: ClubModel
    @EnvironmentObject var currentUser: CurrentUser
    
    var body: some View {
        VStack {
            
            ClubHeader(picture: clubModel.club!.picture, members: clubModel.club!.members.count, description: clubModel.club!.description)
            
            Divider()
                .padding(.vertical, 10)

            DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                .labelsHidden()
            
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
                        WorkoutRow(title: workout.title, description: workout.description, participants: workout.participants, date: workout.date)
                    }
                }
            }
            Spacer()
        }
        .scrollContentBackground(.hidden)
        .navigationTitle(clubModel.club!.clubName)
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
    JoinedClubView(clubModel: ClubModel()).environmentObject({ () -> CurrentUser in
        let envObj = CurrentUser()
        envObj.user = DBUser(userID: "123", name: "Spas", email: "spas@mail.bg", photoUrl: "", dateCreated: Date())
        return envObj
    }())
}

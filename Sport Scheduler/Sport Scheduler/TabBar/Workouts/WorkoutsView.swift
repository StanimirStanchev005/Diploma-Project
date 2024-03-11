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
            List {
                DatePicker("Select Date", selection: $workoutsModel.selectedDate, displayedComponents: .date)
                    .labelsHidden()
                    .datePickerStyle(.compact)
                if workoutsModel.isTaskInProgress {
                    HStack() {
                        Spacer()
                        ProgressView()
                            .controlSize(.large)
                        Spacer()
                    }
                } else if workoutsModel.workouts.isEmpty && !workoutsModel.isTaskInProgress {
                    Text("You've got no workouts for \(workoutsModel.selectedDate.formatted(date: .abbreviated, time: .omitted)).\nCongrats, you can rest!")
                        .font(.title2)
                        .padding()
                        .multilineTextAlignment(.center)
                } else {
                    ForEach(workoutsModel.workouts, id: \.workoutId.self) { workout in
                        TabBarWorkoutRow(title: workout.title, description: workout.description, club: workout.club, date: workout.date)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Workouts")
        }
        .onAppear() {
            Task {
                workoutsModel.fetchWokrouts(for: currentUser.user!)
            }
        }
        .onChange(of: workoutsModel.selectedDate) {
            workoutsModel.fetchWokrouts(for: currentUser.user!)
        }
        
    }
}

#Preview {
    NavigationStack {
        WorkoutsView().environmentObject({ () -> CurrentUser in
            let envObj = CurrentUser()
            envObj.user = DBUser(userID: "123", name: "Spas", email: "spas@mail.bg", photoUrl: "", dateCreated: Date())
            return envObj
        }() )
    }
}

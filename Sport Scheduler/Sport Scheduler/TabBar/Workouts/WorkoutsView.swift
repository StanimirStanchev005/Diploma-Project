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
                ForEach(workoutsModel.workouts, id: \.workoutId.self) { workout in
                    TabBarWorkoutRow(title: workout.title, description: workout.description, club: workout.club, date: workout.date)
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
    NavigationStack {
        WorkoutsView().environmentObject({ () -> CurrentUser in
            let envObj = CurrentUser()
            envObj.user = DBUser(userID: "123", name: "Spas", email: "spas@mail.bg", photoUrl: "", dateCreated: Date())
            return envObj
        }() )
    }
}

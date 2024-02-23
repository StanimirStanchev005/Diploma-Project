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
            DatePicker("Select Date", selection: $workoutsModel.selectedDate, displayedComponents: .date)
                .labelsHidden()
                .datePickerStyle(.compact)
            
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

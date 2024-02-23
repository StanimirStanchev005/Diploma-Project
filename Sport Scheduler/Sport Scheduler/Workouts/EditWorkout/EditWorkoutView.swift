//
//  EditWorkoutView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 24.01.24.
//

import SwiftUI

struct EditWorkoutView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var editWorkoutModel = EditWorkoutModel()
    @State var workout: Workout
    let clubID: String
    
    var body: some View {
        VStack(spacing: 0) {
            Form {
                DatePicker("Date", selection: $workout.date)
                
                CustomRow(label: "Title", placeholder: "Title", text: $workout.title)
                
                CustomRow(label: "Description", placeholder: "Description", text: $workout.description)
            }
        }
        .navigationTitle("Edit Workout")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing ) {
                Button("Save") {
                    do {
                        try editWorkoutModel.updateWorkout(for: clubID, with: workout)
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}

#Preview {
    EditWorkoutView(workout: Workout(clubId: "Levski", title: "Title", date: Date(),  isRepeating: true), clubID: "")
}

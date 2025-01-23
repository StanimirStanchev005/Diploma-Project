//
//  EditWorkoutView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 24.01.24.
//

import SwiftUI

struct EditWorkoutView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var workout: Workout
    private let editWorkoutModel = EditWorkoutModel()
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
                    editWorkoutModel.updateWorkout(for: clubID, with: workout)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

#Preview {
    EditWorkoutView(workout: Workout(clubId: "Levski", title: "Title", date: Date()), clubID: "")
}

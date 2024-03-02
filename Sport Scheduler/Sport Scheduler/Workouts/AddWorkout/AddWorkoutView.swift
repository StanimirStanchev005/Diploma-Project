//
//  AddWorkoutView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 20.01.24.
//

import SwiftUI

struct AddWorkoutView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var addWorkoutModel = AddWorkoutModel()
    let clubID: String
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Form {
                    DatePicker("Date", selection: $addWorkoutModel.workoutDate, in: Date.now...)
                    
                    CustomRow(label: "Title", placeholder: "Title", text: $addWorkoutModel.workoutTitle)
                    
                    CustomRow(label: "Description", placeholder: "Description", text: $addWorkoutModel.workoutDescription)
                    
                    Toggle("Add for a Month", isOn: $addWorkoutModel.isRepeating)
                }
            }
            .navigationTitle("Add Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading ) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing ) {
                    Button("Save") {
                        do {
                            try addWorkoutModel.save(for: clubID, title: addWorkoutModel.workoutTitle, description: addWorkoutModel.workoutDescription, date: addWorkoutModel.workoutDate)
                            dismiss()
                        } catch {
                            print(error)
                        }
                    }
                    .disabled(addWorkoutModel.isValidInput)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddWorkoutView(clubID: "")
    }
}

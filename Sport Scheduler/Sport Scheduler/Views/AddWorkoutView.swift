//
//  AddWorkoutView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 20.01.24.
//

import SwiftUI

struct AddWorkoutView: View {
    @Environment(\.dismiss) var dismiss
    @State private var workoutTime = Date()
    @State private var workoutTitle = ""
    @State private var workoutDescription = ""
    @State private var isRepeating = false
    var body: some View {
        NavigationStack{
            VStack(spacing: 0) {
                Form {
                    DatePicker("Date", selection: $workoutTime, in: Date.now..., displayedComponents: .date)

                    DatePicker("Time", selection: $workoutTime, displayedComponents: .hourAndMinute)
                   
                    CustomRow(label: "Title", placeholder: "Title", text: $workoutTitle)
                    
                    CustomRow(label: "Description", placeholder: "Description", text: $workoutDescription)
                    
                    Toggle("Repeat", isOn: $isRepeating)
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
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddWorkoutView()
    }
}

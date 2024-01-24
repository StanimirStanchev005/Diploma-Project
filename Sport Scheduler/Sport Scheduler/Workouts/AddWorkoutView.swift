//
//  AddWorkoutView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 20.01.24.
//

import SwiftUI

final class AddWorkoutModel: ObservableObject {
    @Published var workoutDate = Date()
    @Published var workoutTime = Date()
    @Published var workoutTitle = ""
    @Published var workoutDescription = ""
    @Published var isRepeating = false
    
    private var formattedDateTime: String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: mergedDate())
        }

        private func mergedDate() -> Date {
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: workoutDate)
            let timeComponents = calendar.dateComponents([.hour, .minute], from: workoutTime)

            return calendar.date(bySettingHour: timeComponents.hour ?? 0, minute: timeComponents.minute ?? 0, second: 0, of: calendar.date(from: dateComponents) ?? Date()) ?? Date()
        }
}

struct AddWorkoutView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var addWorkoutModel = AddWorkoutModel()
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 0) {
                Form {
                    DatePicker("Date", selection: $addWorkoutModel.workoutTime, in: Date.now..., displayedComponents: .date)

                    DatePicker("Time", selection: $addWorkoutModel.workoutTime, displayedComponents: .hourAndMinute)
                   
                    CustomRow(label: "Title", placeholder: "Title", text: $addWorkoutModel.workoutTitle)
                    
                    CustomRow(label: "Description", placeholder: "Description", text: $addWorkoutModel.workoutDescription)
                    
                    Toggle("Repeat", isOn: $addWorkoutModel.isRepeating)
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

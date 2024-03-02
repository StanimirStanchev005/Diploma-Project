//
//  WorkoutView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 23.01.24.
//

import SwiftUI
import CodeScanner

struct WorkoutView: View {
    let workout: Workout
    @StateObject var workoutViewModel = WorkoutViewModel()
    @State private var hasError = false
    
    var body: some View {
        VStack {
            List {
                ForEach(workoutViewModel.workout.participants, id:\.userID) { participant in
                    Text(participant.name)
                }
            }
        }
        .navigationTitle("Participants")
        .toolbar {
            Button("Scan", systemImage: "qrcode.viewfinder") {
                workoutViewModel.isShowingScanner.toggle()
            }
        }
        .sheet(isPresented: $workoutViewModel.isShowingScanner) {
            hasError = workoutViewModel.isShowingError
        } content: {
            CodeScannerView(codeTypes: [.qr], completion: workoutViewModel.handleScan)
        }
        .alert("Error", isPresented: $hasError) {
            Button("OK") {}
        } message: {
            Text(workoutViewModel.errorMessage)
        }
        .onAppear() {
            workoutViewModel.workout = self.workout
        }
    }
}

#Preview {
    NavigationStack {
        WorkoutView(workout: Workout(clubId: "Levski", title: "Title", date: Date()))
    }
}

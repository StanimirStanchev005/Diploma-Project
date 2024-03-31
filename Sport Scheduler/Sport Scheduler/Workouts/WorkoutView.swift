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
    @EnvironmentObject var currentUser: CurrentUser
    @ObservedObject var clubModel: ClubModel
    @StateObject var workoutViewModel = WorkoutViewModel()
    @State private var hasError = false
    
    var isOwner: Bool {
        clubModel.isUserOwner(userId: currentUser.user?.userID)
    }
    
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
            Group {
                if isOwner {
                    Button("Scan", systemImage: "qrcode.viewfinder") {
                        workoutViewModel.isShowingScanner.toggle()
                    }
                }
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
        WorkoutView(workout: Workout(clubId: "Levski", title: "Title", date: Date()), clubModel: ClubModel())
    }
}

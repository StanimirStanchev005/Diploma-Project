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
            Text(workout.description)
                .font(.callout)
                .padding([.bottom, .horizontal], 10)
            Text("Participants")
                .font(.headline)
            List() {
                ForEach(workoutViewModel.workout.participants, id:\.userID) { participant in
                    HStack {
                        Text(participant.name)
                        Spacer()
                        Text("Visited: \(participant.visitedWorkouts)")
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle(workout.title)
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
            workoutViewModel.club = clubModel.club!
        }
    }
}

#Preview {
    NavigationStack {
        WorkoutView(workout: Workout(clubId: "Levski", title: "Title", date: Date()), clubModel: ClubModel())
    }
}

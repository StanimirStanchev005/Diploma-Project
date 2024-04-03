//
//  WorkoutsHistoryView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 2.04.24.
//

import SwiftUI

struct WorkoutsHistoryView: View {
    @ObservedObject var clubModel: ClubModel
    let isOwner: Bool
    
    var body: some View {
        VStack {
            WorkoutListView(clubModel: clubModel, isOwner: isOwner, isHistory: clubModel.isHistory, noWorkoutsMessage: "Your workouts history is empty")
        }
        .onAppear {
            clubModel.isHistory = true
            clubModel.isTaskInProgress = true
            clubModel.clearWorkouts()
            clubModel.fetchWorkouts()
        }
        .navigationTitle("Workouts History")
    }
}

#Preview {
    WorkoutsHistoryView(clubModel: ClubModel(), isOwner: false)
}

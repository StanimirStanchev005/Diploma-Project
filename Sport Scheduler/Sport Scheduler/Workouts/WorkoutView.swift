//
//  WorkoutView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 23.01.24.
//

import SwiftUI

struct WorkoutView: View {
    let workout: Workout
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    WorkoutView(workout: Workout(clubId: "Levski", title: "Title", date: Date(), isRepeating: true))
}

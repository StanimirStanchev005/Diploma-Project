//
//  Workout.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 22.01.24.
//

import Foundation

final class Workout: Codable {
    var workoutId = UUID().uuidString
    var title: String
    var description: String
    var date: Date
    var time: Date
    var participants: [Participants] = []
    var isRepeating: Bool
    
    init(title: String, description: String, date: Date, time: Date, isRepeating: Bool) {
        self.title = title
        self.description = description
        self.date = date
        self.time = time
        self.isRepeating = isRepeating
    }
}

struct Participants: Codable {
    let userId: String
    let name: String
    let image: String
}

//
//  Workout.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 22.01.24.
//

import Foundation

final class Workout: Codable {
    var workoutId = UUID().uuidString
    var clubId: String
    var title: String
    var description: String
    var date: Date
    var participants: [Participants] = []
    var isRepeating: Bool
    
    init(clubId: String, title: String, description: String = "", date: Date, isRepeating: Bool) {
        self.clubId = clubId
        self.title = title
        self.description = description
        self.date = date
        self.isRepeating = isRepeating
    }
}

struct Participants: Codable {
    let userId: String
    let name: String
    let image: String
}

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
    var participants: [ClubUserModel] = []
    
    init(clubId: String, title: String, description: String = "", date: Date) {
        self.clubId = clubId
        self.title = title
        self.description = description
        self.date = date
    }
}


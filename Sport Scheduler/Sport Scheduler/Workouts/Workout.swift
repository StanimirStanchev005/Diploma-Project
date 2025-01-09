//
//  Workout.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 22.01.24.
//

import Foundation

@Observable final class Workout: Codable, Equatable, @unchecked Sendable {

    enum CodingKeys: CodingKey {
        case workoutId, clubId, title, description, date, participants
    }

    let workoutId: String
    let clubId: String
    var title: String
    var description: String
    var date: Date
    var participants: [ClubUserModel] = []
    
    init(clubId: String, title: String, description: String = "", date: Date, workoutId: String = UUID().uuidString) {
        self.clubId = clubId
        self.title = title
        self.description = description
        self.date = date
        self.workoutId = workoutId
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        workoutId = try container.decode(String.self, forKey: .workoutId)
        clubId = try container.decode(String.self, forKey: .clubId)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        date = try container.decode(Date.self, forKey: .date)
        participants = try container.decodeIfPresent([ClubUserModel].self, forKey: .participants) ?? []
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(workoutId, forKey: .workoutId)
        try container.encode(clubId, forKey: .clubId)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(date, forKey: .date)
        try container.encode(participants, forKey: .participants)
    }

    static func ==(lhs: Workout, rhs: Workout) -> Bool {
        lhs.workoutId == rhs.workoutId
    }
}


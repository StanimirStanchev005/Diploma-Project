//
//  ClubModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 10.12.23.
//

import Foundation

final class Club: Identifiable, Codable, @unchecked Sendable {

    enum CodingKeys: CodingKey {
        case ownerId
        case clubName
        case description
        case category
        case picture
        case members
    }

    var id: String {
        clubName
    }
    let ownerId: String
    var clubName: String
    var description: String
    var category: String
    var picture = "ClubPlaceholder"
    var members: [ClubUserModel] = []
    
    init(clubName: String, description: String, category: String, ownerId: String) {
        self.clubName = clubName
        self.description = description
        self.category = category
        self.ownerId = ownerId
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.clubName = try container.decode(String.self, forKey: .clubName)
        self.category = try container.decode(String.self, forKey: .category)
        self.ownerId = try container.decode(String.self, forKey: .ownerId)
        self.picture = try container.decode(String.self, forKey: .picture)
        self.description = try container.decode(String.self, forKey: .description)
        self.members = try container.decodeIfPresent([ClubUserModel].self, forKey: .members) ?? []
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ownerId, forKey: .ownerId)
        try container.encode(clubName, forKey: .clubName)
        try container.encode(description, forKey: .description)
        try container.encode(category, forKey: .category)
        try container.encode(picture, forKey: .picture)
        try container.encode(members, forKey: .members)
    }

}

struct ClubUserModel: Codable {
    let userID: String
    let name: String
    var visitedWorkouts: Int = 0
}


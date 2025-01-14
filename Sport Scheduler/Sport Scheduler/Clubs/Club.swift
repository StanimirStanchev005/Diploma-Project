//
//  ClubModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 10.12.23.
//

import Foundation

struct Club: Codable, Identifiable {

    let ownerId: String
    var clubName: String
    var description: String
    var category: String
    var picture = "ClubPlaceholder"
    var members: [ClubUserModel] = []
    var id: String {
        clubName
    }

    init(ownerId: String, clubName: String, description: String, category: String) {
        self.ownerId = ownerId
        self.clubName = clubName
        self.description = description
        self.category = category
    }
}

struct ClubUserModel: Codable {
    let userID: String
    let name: String
    var visitedWorkouts: Int = 0
}


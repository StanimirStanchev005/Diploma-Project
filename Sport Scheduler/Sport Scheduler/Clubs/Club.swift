//
//  ClubModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 10.12.23.
//

import Foundation

@MainActor
final class Club {

    var data: ClubData

    init(clubName: String, description: String, category: String, ownerId: String) {
        data = ClubData(ownerId: ownerId,
                        clubName: clubName,
                        description: description,
                        category: category)
    }

    init(data: ClubData) {
        self.data = data
    }
}

struct ClubUserModel: Codable {
    let userID: String
    let name: String
    var visitedWorkouts: Int = 0
}

struct ClubData: Codable, Identifiable {
    let ownerId: String
    var clubName: String
    var description: String
    var category: String
    var picture = "ClubPlaceholder"
    var members: [ClubUserModel] = []
    var id: String {
        clubName
    }
}

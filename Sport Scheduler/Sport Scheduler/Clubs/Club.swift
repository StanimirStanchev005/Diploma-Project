//
//  ClubModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 10.12.23.
//

import Foundation


final class Club: Identifiable, Codable {
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
    
    enum CodingKeys: String, CodingKey {
        case ownerId
        case clubName
        case description
        case category
        case picture
        case members
    }
}

struct ClubUserModel: Codable {
    let userID: String
    let name: String
}


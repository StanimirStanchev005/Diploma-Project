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
    var searchName: [String]
    
    init(clubName: String, description: String, category: String, ownerId: String, searchName: [String]) {
        self.clubName = clubName
        self.description = description
        self.category = category
        self.ownerId = ownerId
        self.searchName = searchName
    }
    
    enum CodingKeys: String, CodingKey {
        case ownerId
        case clubName
        case description
        case category
        case picture
        case members
        case searchName
    }
}

struct ClubUserModel: Codable {
    let userID: String
    let name: String
}


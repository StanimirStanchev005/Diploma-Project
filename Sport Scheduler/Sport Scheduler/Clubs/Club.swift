//
//  ClubModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 10.12.23.
//

import Foundation


final class Club: Identifiable, Codable {
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
    
    var identifier: String {
        UUID().uuidString
    }
}

struct ClubUserModel: Codable {
    let userID: String
    let name: String
}

extension Club: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    public static func == (lhs: Club, rhs: Club) -> Bool {
        lhs.identifier == rhs.identifier
    }
}


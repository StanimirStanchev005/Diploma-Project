//
//  ClubModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 10.12.23.
//

import Foundation


class Club: Identifiable, Codable {
    let ownerId: String
    var clubName: String
    var description: String
    var category: String
    var picture = "ClubPlaceholder"
    var members: [DBUser] = []
    
    init(clubName: String, description: String, category: String, ownerId: String) {
        self.clubName = clubName
        self.description = description
        self.category = category
        self.ownerId = ownerId
    }
    
    var identifier: String {
        UUID().uuidString
    }
}

extension Club: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    public static func == (lhs: Club, rhs: Club) -> Bool {
        lhs.identifier == rhs.identifier
    }
}


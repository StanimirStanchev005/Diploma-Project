//
//  ClubModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 10.12.23.
//

import Foundation


class Club: Identifiable, Codable {
    var name: String
    var picture = "ClubPlaceholder"
    var members: [DBUser] = []
    
    init(name: String) {
        self.name = name
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


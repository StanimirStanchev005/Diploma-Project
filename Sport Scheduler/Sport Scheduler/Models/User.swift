//
//  UserModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 10.12.23.
//

import Foundation

class User: Codable {
    
    var name: String
    var picture = "UserPlaceholder"
    var joinedClubs: [Club] = []
    var ownedClubs: [Club] = []
    var subscribed = false
    var remainingWorkouts = 0
    
    init(name: String) {
        self.name = name
    }
}

extension User: Hashable {
    var identifier: String {
        return UUID().uuidString
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    
    public static func == (lhs: User, rhs: User) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

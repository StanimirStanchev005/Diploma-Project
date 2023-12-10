//
//  UserModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 10.12.23.
//

import Foundation

@Observable
class Users {
  
    let id = UUID()
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

extension Users: Hashable {
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    public static func == (lhs: Users, rhs: Users) -> Bool {
        return lhs.id == rhs.id
    }
}

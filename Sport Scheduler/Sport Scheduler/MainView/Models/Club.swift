//
//  ClubModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 10.12.23.
//

import Foundation

@Observable
class Club: Identifiable {
    let name: String
    let picture = "ClubPlaceholder"
    let members: [Users] = []
    
    init(name: String) {
        self.name = name
    }
}

extension Club: Hashable {
    var identifier: String {
        return UUID().uuidString
    }
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    
    public static func == (lhs: Club, rhs: Club) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}


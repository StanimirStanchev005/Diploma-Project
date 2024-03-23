//
//  Plans.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 23.03.24.
//

import Foundation

enum Plans: Int, CaseIterable {
    case standard
    case gold
    case diamond
    
    var plan: PremiumPlan {
        switch self {
        case .standard:
            return PremiumPlan(tier: 3, title: "Standard", extras: "No benefits, but hey, it's free.", price: 0)
        case .gold:
            return PremiumPlan(tier: 2, title: "Gold", extras: "Create up to three clubs", price: 49.99)
        case .diamond:
            return PremiumPlan(tier: 1, title: "Diamond", extras: "Create unlimited amount of clubs", price: 99.99)
        }
    }
}

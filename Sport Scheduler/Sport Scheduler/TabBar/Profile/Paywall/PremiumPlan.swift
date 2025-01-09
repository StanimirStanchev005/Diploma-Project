//
//  PremiumPlan.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 23.03.24.
//

import Foundation

struct PremiumPlan: Codable {
    let tier: Int
    let title: String
    let extras: String
    let price: Double
}

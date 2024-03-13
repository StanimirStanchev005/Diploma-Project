//
//  PaywallModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 13.03.24.
//

import Foundation

final class PaywallModel: ObservableObject {
    @Published var isStandardChosen = false
    @Published var isGoldChosen = false
    @Published var isDiamondChosen = false
}

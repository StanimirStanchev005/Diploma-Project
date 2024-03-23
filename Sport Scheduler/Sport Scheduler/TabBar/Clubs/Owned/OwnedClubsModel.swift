//
//  OwnedClubsModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 23.03.24.
//

import Foundation

final class OwnedClubsModel: ObservableObject {
    @Published var ownedClubs: [UserClubModel] = []
    @Published var showCreateClubView = false
    @Published var showSubscribeAlert = false
    var numberOfClubsAllowed = 0
    
    func checkSubscription(tier: Int?) {
        guard let tier else {
            return
        }
        if tier == Plans.standard.plan.tier {
            numberOfClubsAllowed = 0
        } else if tier == Plans.gold.plan.tier {
            numberOfClubsAllowed = 3
        } else {
            numberOfClubsAllowed = Int.max
        }
    }
    
    func canUserCreateClub(clubs count: Int?) {
        guard let count else {
            return
        }
        if numberOfClubsAllowed > count {
            showCreateClubView = true
        } else {
            showSubscribeAlert = true
        }
    }
}

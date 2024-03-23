//
//  PaywallModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 13.03.24.
//

import Foundation
import FirebaseFirestore

final class PaywallModel: ObservableObject {
    @Published var isStandardChosen = false
    @Published var isGoldChosen = false
    @Published var isDiamondChosen = false
    @Published var isAlertShown = false
    @Published var errorDowngradingPlan = false
    @Published var upgradeSuccess = false
        
    private var userRepository: UserRepository
    
    init(userRepository: UserRepository = FirestoreUserRepository()) {
        self.userRepository = userRepository
    }
    
    var alertTitle: String {
        if isStandardChosen {
            return Plans.standard.plan.title
        } else if isGoldChosen {
            return Plans.gold.plan.title
        } else {
            return Plans.diamond.plan.title
        }
    }
    
    var alertMessage: String {
        if isStandardChosen {
            return "This is the default plan. You can't upgrade or downgrade to this plan!"
        } else if isGoldChosen {
            return "You are about to upgrade to \(Plans.gold.plan.title) plan.\nAre you sure you want to continue?"
        } else {
            return "You are about to upgrade to \(Plans.diamond.plan.title) plan.\nAre you sure you want to continue?"
        }
    }
    
    var alertFunction: (DBUser?) -> () {
        return { user in
            if self.isStandardChosen {
                self.isStandardChosen = false
            } else if self.isGoldChosen {
                self.upgrade(plan: Plans.gold.plan, for: user)
                self.isGoldChosen = false
            } else {
                self.upgrade(plan: Plans.diamond.plan, for: user)
                self.isDiamondChosen = false
            }
        }
    }
    
    func cancelUpgrade() {
        isStandardChosen = false
        isGoldChosen = false
        isDiamondChosen = false
    }
    
    func upgrade(plan: PremiumPlan, for user: DBUser?) {
        guard let user else {
            print("Something went wrong with the user")
            return
        }
        guard user.subscriptionPlan.tier > plan.tier else {
            errorDowngradingPlan = true
            return
        }
        do {
            try userRepository.upgrade(plan: plan, for: user.userID)
            upgradeSuccess = true
        } catch {
            print("Error upgrading plan: \(error)")
        }
    }
}



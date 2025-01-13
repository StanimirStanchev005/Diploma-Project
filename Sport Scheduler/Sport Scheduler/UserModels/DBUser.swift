//
//  UserModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 10.12.23.
//

import Foundation

struct DBUser: Codable, Sendable {

    let userID: String
    var name: String
    let email: String
    var photoUrl: String?
    var joinedClubs: [String] = []
    var ownedClubs: [String] = []
    var subscriptionPlan: PremiumPlan = Plans.standard.plan
    var requests: [UserRequestModel] = []
    let dateCreated: Date

    init(userID: String, name: String, email: String, photoUrl: String?, dateCreated: Date) {
        self.userID = userID
        self.name = name
        self.email = email
        self.photoUrl = photoUrl ?? "UserPlaceholder"
        self.dateCreated = dateCreated
    }
}



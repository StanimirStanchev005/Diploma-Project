//
//  UserModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 10.12.23.
//

import Foundation

final class DBUser: ObservableObject, Codable {
    enum CodingKeys: CodingKey {
        case userID, name, email, photoUrl, joinedClubs, ownedClubs, subscribed, dateCreated
    }
    
    let userID: String
    @Published var name: String
    let email: String
    @Published var photoUrl: String?
    @Published var joinedClubs: [Club] = []
    @Published var ownedClubs: [Club] = []
    @Published var subscribed: Bool = false
    let dateCreated: Date
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        userID = try container.decode(String.self, forKey: .userID)
        email = try container.decode(String.self, forKey: .email)
        photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl) ?? "UserPlaceholder"
        joinedClubs = try container.decodeIfPresent([Club].self, forKey: .joinedClubs) ?? []
        ownedClubs = try container.decodeIfPresent([Club].self, forKey: .ownedClubs) ?? []
        subscribed = try container.decode(Bool.self, forKey: .subscribed)
        dateCreated = try container.decode(Date.self, forKey: .dateCreated)
    }
    
    init(userID: String, name: String, email: String, photoUrl: String?, dateCreated: Date) {
        self.userID = userID
        self.name = name
        self.email = email
        self.photoUrl = photoUrl ?? "UserPlaceholder"
        self.dateCreated = dateCreated
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userID, forKey: .userID)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(photoUrl, forKey: .photoUrl)
        try container.encode(joinedClubs, forKey: .joinedClubs)
        try container.encode(ownedClubs, forKey: .ownedClubs)
        try container.encode(subscribed, forKey: .subscribed)
        try container.encode(dateCreated, forKey: .dateCreated)
        
    }
}

final class CurrentUser: ObservableObject {
    @Published var user: DBUser?
    @Published var showSignInView = true
}

//
//  UserModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 10.12.23.
//

import Foundation

final class DBUser: ObservableObject, Codable {
    enum CodingKeys: CodingKey {
        case userID, name, email, photoUrl, joinedClubs, ownedClubs, requests, dateCreated
    }
    
    let userID: String
    @Published var name: String
    let email: String
    @Published var photoUrl: String?
    @Published var joinedClubs: [UserClubModel] = []
    @Published var ownedClubs: [UserClubModel] = []
    @Published var subscribed: Bool = false
    var requests: [UserRequestModel] = []
    let dateCreated: Date
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        userID = try container.decode(String.self, forKey: .userID)
        email = try container.decode(String.self, forKey: .email)
        photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl) ?? "UserPlaceholder"
        joinedClubs = try container.decodeIfPresent([UserClubModel].self, forKey: .joinedClubs) ?? []
        ownedClubs = try container.decodeIfPresent([UserClubModel].self, forKey: .ownedClubs) ?? []
        requests = try container.decode([UserRequestModel].self, forKey: .requests) 
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
        try container.encode(requests, forKey: .requests)
        try container.encode(dateCreated, forKey: .dateCreated)
    }
}



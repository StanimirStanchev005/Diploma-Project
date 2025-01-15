//
//  UserRequestModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 2.03.24.
//

struct UserRequestModel: Codable {
    let requestID: String
    let clubID: String
    var status: String = RequestStatus.pending.rawValue
}

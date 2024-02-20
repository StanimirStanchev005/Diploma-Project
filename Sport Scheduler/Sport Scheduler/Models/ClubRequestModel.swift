//
//  JoinRequestModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 18.02.24.
//

import Foundation

enum RequestStatus: String, CaseIterable {
    case pending
    case accepted
    case rejected
    
    var rawValue: String {
        switch self {
        case .pending:
            return "Pending"
        case .accepted:
            return "Accepted"
        case .rejected:
            return "Rejected"
        }
    }
}

struct ClubRequestModel: Codable {
    var requestID = UUID().uuidString
    var status: String = RequestStatus.pending.rawValue
    let userID: String
    let userName: String
    var date = Date()
}

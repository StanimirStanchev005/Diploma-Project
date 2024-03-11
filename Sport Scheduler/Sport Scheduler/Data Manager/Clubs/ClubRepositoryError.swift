//
//  ClubRepositoryError.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 9.03.24.
//

import Foundation

enum ClubRepositoryError: Error {
    case alreadyExists
    case networkError
    
    var localizedDescription: String {
        switch self {
        case .alreadyExists:
            "Club with this name already exists! Use a different name!"
        case .networkError:
            "Network connetion failed!"
        }
    }
}

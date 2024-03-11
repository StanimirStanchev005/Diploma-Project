//
//  AuthError.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 9.03.24.
//

import Foundation

enum AuthError: Error {
    case emailAlreadyInUse
    case networkError
    case invalidEmailOrPassword
    
    var localizedDescription: String {
        switch self {
            
        case .emailAlreadyInUse:
            "This email is already in use! Use a different email!"
        case .invalidEmailOrPassword:
            "Invalid email or password!"
        case .networkError:
            "Network connetion failed!"
        }
    }
}

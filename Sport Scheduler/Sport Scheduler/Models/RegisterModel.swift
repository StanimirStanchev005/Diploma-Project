//
//  RegisterModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 8.12.23.
//

import Foundation
import Firebase

@Observable
class RegisterModel {
    var fullName = ""
    var email = ""
    var password = ""
    
    var isFullNameValid: Bool {
        !fullName.isEmpty
    }
    
    var isEmailValid: Bool {
        NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}+").evaluate(with: email)
    }
    
    var isPasswordValid: Bool {
        password.count >= 8
    }
    
    var isInputValid: Bool {
        isFullNameValid && isEmailValid && isPasswordValid
    }
}

extension RegisterModel {
    func validFullname() -> Bool {
        if fullName.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 || fullName.isEmpty {
            return false
        } else {
            return !isFullNameValid
        }
    }
    
    func validEmail() -> Bool {
        if email.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            return false
        } else {
            return !isEmailValid
        }
    }
    
    func validPassword() -> Bool {
        if password.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            return false
        } else {
            return !isPasswordValid
        }
        
    }
}

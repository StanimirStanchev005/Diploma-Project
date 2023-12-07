//
//  LoginModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 7.12.23.
//

import Foundation

@Observable
class LoginModel {
    var email = ""
    var password = ""
   
    var isValid: Bool {
        return true
    }
}

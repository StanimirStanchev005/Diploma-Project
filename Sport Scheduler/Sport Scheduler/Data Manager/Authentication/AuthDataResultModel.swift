//
//  AuthDataResultModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 9.03.24.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let name: String?
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.name = user.displayName
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

//
//  CurrentUser.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 2.03.24.
//

import Foundation

@Observable
final class CurrentUser {
    var user: DBUser?
    var state = ContentViewScreenState.loading

    func updateUser(with newUser: DBUser) {
        self.user = newUser
    }
}

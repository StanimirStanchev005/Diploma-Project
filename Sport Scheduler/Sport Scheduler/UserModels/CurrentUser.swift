//
//  CurrentUser.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 2.03.24.
//

import Foundation

final class CurrentUser: ObservableObject {
    @Published var user: DBUser?
    @Published var state = ContentViewScreenState.loading

    func updateUser(with newUser: DBUser) {
        self.user = newUser
    }
}

//
//  ProfileModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 13.12.23.
//

import Foundation

@MainActor
final class ProfileModel: ObservableObject {
    
    @Published private(set) var user: AuthDataResultModel? = nil
    
    func laodCurrentUser() throws {
        self.user = try AuthenticationManager.shared.getAuthenticatedUser()
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
}

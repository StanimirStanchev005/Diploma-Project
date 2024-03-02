//
//  CurrentUser.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 2.03.24.
//

import Foundation

final class CurrentUser: ObservableObject {
    @Published var user: DBUser?
    @Published var showSignInView = false
    
    func addOwnedClub(club: Club) {
        self.user!.ownedClubs.append(UserClubModel(name: club.clubName, picture: club.picture))
    }
    
    func addRequest(requestID: String, clubID: String) {
        self.user!.requests.append(UserRequestModel(requestID: requestID, clubID: clubID))
    }
}

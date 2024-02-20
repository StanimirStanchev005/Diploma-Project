//
//  LockedClubModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 15.02.24.
//

import Foundation
import FirebaseFirestore

final class LockedClubModel: ObservableObject {
    private var clubRepository: ClubRepository
    private var userRepository: UserRepository
    
    @Published var club: Club?
    
    init(clubRepository: ClubRepository = Firestore.firestore(),
         userRepository: UserRepository = Firestore.firestore()) {
        self.clubRepository = clubRepository
        self.userRepository = userRepository
    }
    
    func fetchData(for clubId: String) async throws {
        let fetchedClub = try await clubRepository.getClub(clubId: clubId)
        
        Task {
            await MainActor.run {
                self.club = fetchedClub
            }
        }
    }
    
    func sendJoinRequest(for clubId: String, request: ClubRequestModel) throws {
        try clubRepository.sendJoinRequest(for: clubId, from: request.userID, with: request.userName)
    }
}

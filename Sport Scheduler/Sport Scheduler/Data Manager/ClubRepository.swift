//
//  Club Repository.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 8.01.24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

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

protocol ClubRepository {
    func create(club: Club) async throws
    func getClub(clubId: String) async throws -> Club
}

extension Firestore: ClubRepository {
    func create(club: Club) async throws {
        let clubReference = collection("clubs").document(club.clubName)
        do {
            if try await clubReference.getDocument().exists {
                throw ClubRepositoryError.alreadyExists
            }
            try await clubReference.setData(from: club, merge: false)
        } catch {
            let error = error as NSError
            
            switch error.code {
            case FirestoreErrorCode.deadlineExceeded.rawValue:
                throw ClubRepositoryError.networkError
            default:
                throw ClubRepositoryError.alreadyExists
            }
            
        }
    }
    
    func getClub(clubId: String) async throws -> Club {
        try await collection("clubs").document(clubId).getDocument(as: Club.self)
    }
}


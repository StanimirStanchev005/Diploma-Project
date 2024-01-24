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
    func addWorkout(for clubId: String, workout: Workout) throws
    func getWorkouts(for clubId: String, on date: Date) async throws -> [Workout]
    func deleteWorkout(for clubId: String, with workoutId: String) throws
}

extension Firestore: ClubRepository {
    func create(club: Club) async throws {
        do {
            if try await collection("clubs").document(club.clubName).getDocument().exists {
                throw ClubRepositoryError.alreadyExists
            }
            try await collection("clubs").document(club.clubName).setData(from: club, merge: false)
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
    
    func addWorkout(for clubId: String, workout: Workout) throws {
        try collection("clubs").document(clubId).collection("workouts").document(workout.workoutId).setData(from: workout, merge: true)
    }
        
    func getWorkouts(for clubId: String, on date: Date) async throws -> [Workout] {
        let startDate = Calendar.current.startOfDay(for: date)
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!

        let querySnapshot = try await collection("clubs").document(clubId).collection("workouts")
            .whereField("date", isGreaterThanOrEqualTo: startDate)
            .whereField("date", isLessThanOrEqualTo: endDate)
            .getDocuments()
        
        return try querySnapshot.documents.compactMap { document in
            try document.data(as: Workout.self)
        }
    }
    
    func deleteWorkout(for clubId: String, with workoutId: String) throws {
        collection("clubs").document(clubId).collection("workouts").document(workoutId).delete()
    }
}


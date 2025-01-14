//
//  WorkoutViewModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 29.02.24.

import Foundation
import CodeScanner
import FirebaseFirestore

@MainActor
@Observable final class WorkoutViewModel {
    private let clubRepository: ClubRepository
    var club: Club = Club(ownerId: "", clubName: "", description: "", category: "")
    var workout: Workout = Workout(clubId: "", title: "", date: Date())
    var isShowingScanner = false
    var isShowingError = false
    var errorMessage = ""
    
    init(clubRepository: ClubRepository = FirestoreClubRepository()) {
        self.clubRepository = clubRepository
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            guard !workout.participants.contains(where: { participant in
                participant.userID == details[0]
            }) else {
                errorMessage = "This user is already registered for this workout"
                isShowingError = true
                return
            }
            guard workout.date - TimeInterval(60 * 30) <= Date() else {
                errorMessage = "It's too early to join this workout. Try again when there are 30 minutes or less before its beginning"
                isShowingError = true
                return
            }
            guard workout.date + TimeInterval(60 * 30) >= Date() else {
                errorMessage = "It's too late to join this workout. 30 minutes have already passed since its beginning."
                isShowingError = true
                return
            }

            let participant = ClubUserModel(userID: details[0], name: details[1])
            do {
                try clubRepository.add(participant: participant, for: self.workout, from: self.club)
                workout.participants.append(participant)
            } catch {
                print("Error adding participant: \(error)")
            }
            
        case .failure(let error):
            self.errorMessage = error.localizedDescription
            isShowingError = true
        }
    }
}

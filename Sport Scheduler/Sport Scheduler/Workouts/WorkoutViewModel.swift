//
//  WorkoutViewModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 29.02.24.
//

import Foundation
import CodeScanner
import FirebaseFirestore

final class WorkoutViewModel: ObservableObject {
    private var clubRepository: ClubRepository
    @Published var workout: Workout = Workout(clubId: "", title: "", date: Date())
    @Published var isShowingScanner = false
    @Published var isShowingError = false
    @Published var errorMessage = ""
    
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
            let participant = ClubUserModel(userID: details[0], name: details[1])
            do {
                try clubRepository.add(participant: participant, for: self.workout)
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

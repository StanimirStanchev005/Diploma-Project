//
//  WorkoutsModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 23.02.24.
//

import FirebaseFirestore

final class WorkoutsModel: ObservableObject {
    private var clubRepository: ClubRepository
    
    @Published var isTaskInProgress = true
    @Published var selectedClub = ""
    @Published var clubWorkouts: [String: PaginatedClubWorkouts] = [ : ]
    
    init(clubRepository: ClubRepository = FirestoreClubRepository()) {
        self.clubRepository = clubRepository
    }
    
    func setupClubWorkouts(with clubs: [UserClubModel]?) {
        guard let clubs else {
            return
        }
        for club in clubs {
            clubWorkouts[club.name] = PaginatedClubWorkouts()
        }
    }
        func getUniqueDates() {
            let calendar = Calendar.current
            let dateSet = Set(clubWorkouts[selectedClub]!.workouts.map { calendar.startOfDay(for: $0.date) })
            clubWorkouts[selectedClub]!.workoutDates = Array(dateSet).sorted()
        }
    
        func filteredWorkouts(on date: Date) -> [Workout] {
            let calendar = Calendar.current
            return clubWorkouts[selectedClub]!.workouts.filter { calendar.startOfDay(for: $0.date) == date }
        }
    
        func fetchWorkouts(for user: DBUser?) {
            guard let user else {
                print("Unable to find user")
                return
            }
            
            Task {
                do {
                    let (fetchedWorkouts, lastDocument) = try await clubRepository.getWorkouts(for: self.selectedClub, lastDocument: self.clubWorkouts[self.selectedClub]?.lastDocument, history: false)
                    await MainActor.run {
                        for workout in fetchedWorkouts {
                            if !self.clubWorkouts[self.selectedClub]!.workouts.contains(where: { $0 == workout }) {
                                self.clubWorkouts[self.selectedClub]!.workouts.append(workout)
                            }
                        }
                        if let lastDocument {
                            self.clubWorkouts[self.selectedClub]!.lastDocument = lastDocument
                        }
                        getUniqueDates()
                        isTaskInProgress = false
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
        }
}

final class PaginatedClubWorkouts {
    var workoutDates: [Date] = []
    var workouts: [Workout] = []
    var lastDocument: DocumentSnapshot? = nil
}

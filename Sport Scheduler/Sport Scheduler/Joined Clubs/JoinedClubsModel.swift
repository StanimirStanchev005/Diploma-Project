//
//  JoinedClubModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 8.02.24.
//
import FirebaseFirestore

final class JoinedClubsModel: ObservableObject {
    private var clubRepository: ClubRepository
    private var debounceTimer: Timer?
    @Published var searchedClub: String = ""
    @Published private(set) var filteredClubs: [UserClubModel] = []
    
    init(clubRepository: ClubRepository = Firestore.firestore()) {
        self.clubRepository = clubRepository
        
    }
    
    func filterClubs() async throws {
        guard !self.searchedClub.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            DispatchQueue.main.async {
                self.filteredClubs = []
            }
            return
        }
        
        do {
            let filteredClubs = try await clubRepository.searchClub(searchText: self.searchedClub.lowercased())
            DispatchQueue.main.async {
                self.filteredClubs = filteredClubs
            }
        } catch {
            throw error
        }
    }
    
    func applyFilterWithDebounce() {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            Task {
                do {
                    try await self.filterClubs()
                } catch {
                    print(error)
                }
            }
        }
        
    }
}

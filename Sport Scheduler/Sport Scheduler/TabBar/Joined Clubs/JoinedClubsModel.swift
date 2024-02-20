//
//  JoinedClubModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 8.02.24.
//
import FirebaseFirestore
import Combine

final class JoinedClubsModel: ObservableObject {
    private var clubRepository: ClubRepository
    private var cancellables = Set<AnyCancellable>()
    @Published var joinedClubs: [UserClubModel] = []
    @Published var searchedClub: String = ""
    @Published private(set) var filteredClubs: [UserClubModel] = []
    
    init(clubRepository: ClubRepository = Firestore.firestore()) {
        self.clubRepository = clubRepository
        
        addSubscribers()
    }
    
    private func addSubscribers() {
        $searchedClub
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { searchedClub in
                
                self.filterClubs(searchText: searchedClub)
                
            }
            .store(in: &cancellables)
    }
    
    private func filterClubs(searchText: String) {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            filteredClubs = []
            return
        }
        Task {
            do {
                let filteredClubs = try await clubRepository.searchClub(searchText: searchText.lowercased())
                await MainActor.run {
                    self.filteredClubs = filteredClubs
                }
            } catch {
                throw error
            }
        }
    }
    
    func fetchJoinedClubs(for user: DBUser) {
       
    }
}

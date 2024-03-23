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
    @Published var searchQuery: String = ""
    @Published private(set) var filteredClubs: [UserClubModel] = []
    private var clubs: [Club] = []
    
    init(clubRepository: ClubRepository = FirestoreClubRepository()) {
        self.clubRepository = clubRepository
        
        addSubscribers()
    }
    
    func triggerListener() {
        clubRepository.listenForClubChanges { [weak self] clubs in
            guard let self = self else {
                print("Unable to update clubs")
                return
            }
            guard self.clubs.count != clubs.count else {
                return
            }
            self.clubs = clubs
        }
    }
    
    private func addSubscribers() {
        $searchQuery
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { searchedClub in
                self.filterClubs(searchText: searchedClub)
            }
            .store(in: &cancellables)
    }
    
    func searchClub(searchText: String, clubs: [Club]) -> [UserClubModel] {
        let searchText = searchText.lowercased()
        return clubs.filter { club in
            club.clubName.lowercased().contains(searchText)
        }
        .map { club in
            UserClubModel(name: club.clubName, picture: club.picture)
        }
    }
    
    private func filterClubs(searchText: String) {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            filteredClubs = []
            return
        }
        filteredClubs = searchClub(searchText: searchText.lowercased(), clubs: clubs)
    }
}

//
//  JoinedClubModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 8.02.24.
//
import FirebaseFirestore
import Combine

final class TabBarClubsModel: ObservableObject {
    private var clubRepository: ClubRepository
    private var cancellables = Set<AnyCancellable>()
    private var clubs: [Club] = []
    @Published var searchQuery: String = ""
    @Published private(set) var filteredClubs: [UserClubModel] = []
    @Published var ownedClubs: [UserClubModel] = []
    @Published var joinedClubs: [UserClubModel] = []
    @Published var showCreateClubView = false
    @Published var showSubscribeAlert = false
    var numberOfClubsAllowed = 0
    var mappedClubs: [UserClubModel] {
        clubs.map { club in
            UserClubModel(name: club.clubName, picture: club.picture)
        }
    }
    init(clubRepository: ClubRepository = FirestoreClubRepository()) {
        self.clubRepository = clubRepository
        
        addSubscribers()
    }
    
    func filterUserClubs(by clubsToFilter: [String]) -> [UserClubModel] {
        let mappedClubs = clubs.map { club in
            UserClubModel(name: club.clubName, picture: club.picture)
        }
        return mappedClubs.filter { club in
            clubsToFilter.contains { $0 == club.name }
        }
    }
    
    func triggerListener() {
        clubRepository.listenForClubChanges { [weak self] clubs in
            guard let self = self else {
                print("Unable to update clubs")
                return
            }
            self.clubs = clubs
        }
    }
    
    private func addSubscribers() {
        $searchQuery
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
    
    func checkSubscription(tier: Int?) {
        guard let tier else {
            return
        }
        if tier == Plans.standard.plan.tier {
            numberOfClubsAllowed = 0
        } else if tier == Plans.gold.plan.tier {
            numberOfClubsAllowed = 3
        } else {
            numberOfClubsAllowed = Int.max
        }
    }
    
    func canUserCreateClub(clubs count: Int?) {
        guard let count else {
            return
        }
        if numberOfClubsAllowed > count {
            showCreateClubView = true
        } else {
            showSubscribeAlert = true
        }
    }
    
}

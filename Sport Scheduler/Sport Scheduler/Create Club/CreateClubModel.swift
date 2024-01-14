//
//  CreateClubModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 8.01.24.
//

import Foundation
import FirebaseFirestore

final class CreateClubModel: ObservableObject {
    private var clubRepository: ClubRepository
    private var userRepository: UserRepository
    
    init(clubRepository: ClubRepository = Firestore.firestore(), 
         userRepository: UserRepository = Firestore.firestore()) {
        self.clubRepository = clubRepository
        self.userRepository = userRepository
    }
    
    @Published var sports = ["Archery", "Athletics", "Badminton", "Basketball", "Boxing", "BreakDance", "Canoeing", "Cycling", "Diving", "Equestrian", "Fencing", "Football", "Golf", "Gymnastics", "Handball", "Hockey", "Judo", "Modern Pentathlon", "Rowing", "Rugby Sevens", "Sailing", "Shooting", "Swimming", "Synchronized Swimming", "Table Tennis", "Taekwondo", "Tennis", "Triathlon", "Volleyball", "Water Polo", "Weightlifting", "Wrestling"]
    
    @Published var name = ""
    @Published var description = ""
    @Published var isValidRepresenter = false
    @Published var selectedSport: String = "Football"
    @Published var hasError = false
    @Published var localizedError: String = "There was an error creating the club! Please try again!"
    
    var isInputValid: Bool {
        isValidRepresenter && !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func create(club: Club, for user: DBUser) async throws {
        do {
            try await clubRepository.create(club: club)
            user.addOwnedClub(club: club)
            try userRepository.save(user: user)
           } catch let error as ClubRepositoryError {
               DispatchQueue.main.async {
                   self.hasError = true
                   self.localizedError = error.localizedDescription
               }
           } catch {
               DispatchQueue.main.async {
                   self.hasError = true
                   self.localizedError = "There was an error creating the club! Please try again!"
               }
           }
            guard hasError == false else {
                return
            }
    }
}

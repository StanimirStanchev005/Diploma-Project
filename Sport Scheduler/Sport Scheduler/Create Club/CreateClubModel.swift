//
//  CreateClubModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 8.01.24.
//

import Foundation
import FirebaseFirestore
import SwiftUI
import PhotosUI

final class CreateClubModel: ObservableObject {
    private var clubRepository: ClubRepository
    private var userRepository: UserRepository
    private var storageRepository: ClubStorageRepository
    
    @Published var sports = ["Archery", "Athletics", "Badminton", "Basketball", "Boxing", "BreakDance", "Canoeing", "Cycling", "Diving", "Equestrian", "Fencing", "Football", "Golf", "Gymnastics", "Handball", "Hockey", "Judo", "Modern Pentathlon", "Rowing", "Rugby Sevens", "Sailing", "Shooting", "Swimming", "Synchronized Swimming", "Table Tennis", "Taekwondo", "Tennis", "Triathlon", "Volleyball", "Water Polo", "Weightlifting", "Wrestling"]
    
    @Published var name = ""
    @Published var description = ""
    @Published var isValidRepresenter = false
    @Published var selectedSport: String = "Football"
    @Published var photo: Image = Image("ClubPlaceholder")
    @Published var hasError = false
    @Published var localizedError: String = "There was an error creating the club! Please try again!"
    @Published var selectedItem: PhotosPickerItem?
    @Published var clubCreationSuccess = false
    @Published var isTaskInProgress = false
    
    init(clubRepository: ClubRepository = FirestoreClubRepository(), storageRepository: ClubStorageRepository = FirebaseClubStorageRepository(),
         userRepository: UserRepository = FirestoreUserRepository()) {
        self.clubRepository = clubRepository
        self.storageRepository = storageRepository
        self.userRepository = userRepository
    }
    
    var isInputValid: Bool {
        isValidRepresenter && !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func convertDataToImage() {
        guard let selectedItem else { return }
        Task {
            do {
                if let image = try await selectedItem.loadTransferable(type: Image.self) {
                    await MainActor.run {
                        self.photo = image
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    func create(club: Club, for userID: String, photo: PhotosPickerItem?) {
        isTaskInProgress = true
        Task {
            do {
                try await clubRepository.create(club: club)
                try userRepository.addClub(for: userID, clubName: club.clubName, clubPicture: club.picture)
                if let photo {
                    try await saveClubImage(item: photo, club: club.id)
                }
                await MainActor.run {
                    isTaskInProgress = false
                    clubCreationSuccess = true
                }
            } catch let error as ClubRepositoryError {
                await MainActor.run {
                    self.isTaskInProgress = false
                    self.hasError = true
                    self.localizedError = error.localizedDescription
                }
            }
        }
    }
    
    func saveClubImage(item: PhotosPickerItem, club name: String) async throws {
        guard let data = try await item.loadTransferable(type: Data.self) else { return }
        let returnedData = try await storageRepository.saveImage(data: data, name: name)
        let url = try  await storageRepository.getUrlFromImage(path: returnedData.path)
        try clubRepository.updateClubPicture(clubID: name, pictureUrl: url.absoluteString)
    }
}

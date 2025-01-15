//
//  CreateClubModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 8.01.24.
//

import FirebaseFirestore
import SwiftUI
import PhotosUI

@Observable final class CreateClubModel {

    enum CreateClubImageState {
        case empty
        case loading
        case success
    }

    private let clubRepository: ClubRepository
    private let userRepository: UserRepository
    private let storageRepository: ClubStorageRepository

    let sports = ["Archery", "Athletics", "Badminton", "Basketball", "Boxing", "BreakDance", "Canoeing", "Cycling", "Diving", "Equestrian", "Fencing", "Football", "Golf",
                  "Gymnastics", "Handball", "Hockey", "Judo", "Modern Pentathlon", "Rowing", "Rugby Sevens", "Sailing", "Shooting", "Swimming", "Synchronized Swimming",
                  "Table Tennis", "Taekwondo", "Tennis", "Triathlon", "Volleyball", "Water Polo", "Weightlifting", "Wrestling"]

    var name = ""
    var description = ""
    var isValidRepresenter = false
    var selectedSport: String = "Football"
    var photo: Image = Image("ClubPlaceholder")
    var hasError = false
    private(set) var localizedError: String = "There was an error creating the club! Please try again!"
    var selectedItem: PhotosPickerItem?
    var clubCreationSuccess = false
    var imageState = CreateClubImageState.empty
    private(set) var isTaskInProgress = false

    init(clubRepository: ClubRepository = FirestoreClubRepository(),
         storageRepository: ClubStorageRepository = FirebaseClubStorageRepository(),
         userRepository: UserRepository = FirestoreUserRepository()) {
        self.clubRepository = clubRepository
        self.storageRepository = storageRepository
        self.userRepository = userRepository
    }

    var isInputValid: Bool {
        isValidRepresenter && !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    @MainActor func convertDataToImage() {
        guard let selectedItem else { return }
        imageState = .loading
        Task {
            do {
                if let image = try await selectedItem.loadTransferable(type: Image.self) {
                        self.photo = image
                        imageState = .success
                }
            } catch {
                print(error)
            }
        }
    }

    @MainActor func create(club: Club, for userID: String, photo: PhotosPickerItem?) {
        isTaskInProgress = true
        Task {
            do {
                try await clubRepository.create(club: club)
                try userRepository.addClub(for: userID, clubName: club.clubName)
                if let photo {
                    try await saveClubImage(item: photo, club: club.id)
                }
                isTaskInProgress = false
                clubCreationSuccess = true
            } catch let error as ClubRepositoryError {
                self.isTaskInProgress = false
                self.hasError = true
                self.localizedError = error.localizedDescription
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

//
//  ClubModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 22.01.24.
//

import Foundation
@preconcurrency import FirebaseFirestore
import SwiftUI
import PhotosUI

enum ClubScreenState {
    case loading
    case club(Club)
    // Add error state
}

@Observable
final class ClubModel {

    enum ClubWorkoutKey: String {
        case future = "future"
        case history = "history"
    }

    private var clubRepository: ClubRepository
    private var userRepository: UserRepository
    private var storageRepository: ClubStorageRepository
    var club: Club?
    private(set) var clubWorkouts: [String: PaginatedClubWorkouts] = [
        "future" : PaginatedClubWorkouts(),
        "history" : PaginatedClubWorkouts()
    ]
    var userRequests: [ClubRequestModel] = []
    var isTaskInProgress = true
    var state: ClubScreenState
    var errorMessage = ""
    var selectedItem: PhotosPickerItem?
    var isHistory = false
    var key: ClubWorkoutKey = .future

    init(clubRepository: ClubRepository = FirestoreClubRepository(), storageRepository: ClubStorageRepository = FirebaseClubStorageRepository(),
         userRepository: UserRepository = FirestoreUserRepository()) {
        self.clubRepository = clubRepository
        self.storageRepository = storageRepository
        self.userRepository = userRepository
        state = .loading
    }

    func clearFutureWorkouts() {
        if let data = clubWorkouts["future"] {
            data.workouts = []
            data.workoutDates = []
            data.lastDocument = nil
        }
    }

    func getUniqueDates(isHistory: Bool) {
        let calendar = Calendar.current
        if isHistory {
            let dateSet = Set(clubWorkouts["history"]!.workouts.map { calendar.startOfDay(for: $0.date) })
            clubWorkouts["history"]!.workoutDates = Array(dateSet).sorted(by: >)
        } else {
            let dateSet = Set(clubWorkouts["future"]!.workouts.map { calendar.startOfDay(for: $0.date) })
            clubWorkouts["future"]!.workoutDates = Array(dateSet).sorted()
        }

    }

    func filteredWorkouts(on date: Date) -> [Workout] {
        let calendar = Calendar.current
        return clubWorkouts[key.rawValue]!.workouts.filter { calendar.startOfDay(for: $0.date) == date }
    }

    func isUserOwner(userId: String?) -> Bool {
        guard let userId else {
            return false
        }
        return club?.ownerId == userId
    }

    func isJoined(joinedClubs: [String]?) -> Bool {
        guard let joinedClubs else {
            return false
        }
        return joinedClubs.contains(where: { club in
            club == self.club?.clubName })
    }

    func visitedWorkouts(for userId: String?) -> Int {
        guard let userId else {
            print("Invalid userId")
            return -1
        }
        let clubMember = club?.members.first { member in
            member.userID == userId
        }
        guard let clubMember else {
            print("No user with this id found in the club")
            return -1
        }
        return clubMember.visitedWorkouts
    }

    @MainActor func triggerClubListeners() {
        Task {
            do {
                for try await result in try await clubRepository.listenForChanges(for: club!.id) {
                    club = result
                }
            } catch {
                throw error
            }
        }
    }

    @MainActor func triggerRequestListeners() {
        Task {
            do {
                for try await result in try await clubRepository.listenForRequestChanges(for: club!.id) {
                    userRequests = result
                }
            } catch {
                throw "Failed to update user requests!"
            }
        }
    }

    @MainActor func fetchData(for clubID: String) {
        Task {
            do {
                let fetchedClub = try await clubRepository.getClub(clubId: clubID)
                self.club = fetchedClub
                self.state = .club(fetchedClub)
                triggerClubListeners()
                triggerRequestListeners()
            } catch {
                throw error
            }
        }
    }
    //Here
    @MainActor func fetchWorkouts() {
        Task {
            do {
                let (fetchedWorkouts, lastDocument) = try await clubRepository.getWorkouts(for: self.club!.clubName, lastDocument: clubWorkouts[key.rawValue]!.lastDocument, history: isHistory)
                for workout in fetchedWorkouts {
                    if !self.clubWorkouts[key.rawValue]!.workouts.contains(where: { $0 == workout }) {
                        self.clubWorkouts[key.rawValue]!.workouts.append(workout)
                    }
                }
                if let lastDocument {
                    self.clubWorkouts[key.rawValue]!.lastDocument = lastDocument
                }
                getUniqueDates(isHistory: isHistory)
                isTaskInProgress = false
            } catch {
                print("Error: \(error)")
            }
        }
    }

    @MainActor func deleteWorkout(id: String) {
        Task {
            do {
                try await clubRepository.deleteWorkout(for: self.club!.clubName, with: id)
                clubWorkouts["future"]!.workouts.removeAll(where: {$0.workoutId == id})
            } catch {
                throw "Error deleting workout: \(error)"
            }
        }
    }

    @MainActor func remove(member: ClubUserModel) {
        Task {
            do {
                try await clubRepository.remove(user: member, from: self.club!)
                club!.members.removeAll(where: { $0.userID == member.userID })
            } catch {
                throw "Error removing user from club: \(error)"
            }
        }
    }

    @MainActor func sendJoinRequest(for clubId: String, request: ClubRequestModel) {
        Task {
            do {
                try await clubRepository.sendJoinRequest(for: clubId, from: request.userID, with: request.userName)
            } catch {
                throw error
            }
        }
    }

    @MainActor func accept(request: ClubRequestModel) {
        Task {
            do {
                try await clubRepository.accept(request: request, from: club!)
                let index = userRequests.firstIndex(where: {newRequest in newRequest.requestID == request.requestID})!
                userRequests[index].status = RequestStatus.accepted.rawValue
                userRequests.remove(at: index)
            } catch {
                throw error
            }
        }

    }

    @MainActor func reject(request: ClubRequestModel) {
        Task {
            do {
                try await clubRepository.reject(request: request, from: club!)
                let index = userRequests.firstIndex(where: {newRequest in newRequest.requestID == request.requestID})!
                userRequests.remove(at: index)
            } catch {
                throw error
            }
        }
    }

    @MainActor func updateClubPicture() {
        guard let club else {
            return
        }
        guard let selectedItem else {
            return
        }
        Task {
            guard let data = try await selectedItem.loadTransferable(type: Data.self) else { return }
            let returnedData = try await storageRepository.saveImage(data: data, name: club.clubName)
            let url = try await storageRepository.getUrlFromImage(path: returnedData.path)
            try await clubRepository.updateClubPicture(clubID: club.clubName, pictureUrl: url.absoluteString)
        }
    }
}

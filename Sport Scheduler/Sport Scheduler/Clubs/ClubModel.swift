//
//  ClubModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 22.01.24.
//

import Foundation
import FirebaseFirestore
import SwiftUI
import PhotosUI

enum ClubScreenState {
    case loading
    case club(Club)
    // Add error state
}

final class ClubModel: ObservableObject {
    private var clubRepository: ClubRepository
    private var userRepository: UserRepository
    private var storageRepository: ClubStorageRepository
    private var lastDocument: DocumentSnapshot? = nil
    
    @Published var club: Club?
    @Published var workouts: [Workout] = []
    @Published var workoutDates: [Date] = []
    @Published var userRequests: [ClubRequestModel] = []
    @Published var isTaskInProgress = true
    @Published var state: ClubScreenState
    @Published var errorMessage = ""
    @Published var selectedItem: PhotosPickerItem?
    var isHistory = false

    func clearWorkouts() {
        self.workouts = []
        self.workoutDates = []
        self.lastDocument = nil
    }
        
    func getUniqueDates(isHistory: Bool) {
        let calendar = Calendar.current
        let dateSet = Set(workouts.map { calendar.startOfDay(for: $0.date) })
        if isHistory {
            workoutDates = Array(dateSet).sorted(by: >)
        } else {
            workoutDates = Array(dateSet).sorted()
        }
        
    }
    
    func filteredWorkouts(for date: Date) -> [Workout] {
        let calendar = Calendar.current
        return workouts.filter { calendar.startOfDay(for: $0.date) == date }
    }
    
    init(clubRepository: ClubRepository = FirestoreClubRepository(), storageRepository: ClubStorageRepository = FirebaseClubStorageRepository(),
         userRepository: UserRepository = FirestoreUserRepository()) {
        self.clubRepository = clubRepository
        self.storageRepository = storageRepository
        self.userRepository = userRepository
        
        state = .loading
    }
    
    func isUserOwner(userId: String?) -> Bool {
        guard let userId else {
            return false
        }
        return club?.ownerId == userId
    }
    
    func isJoined(joinedClubs: [UserClubModel]?) -> Bool {
        guard let joinedClubs else {
            return false
        }
        return joinedClubs.contains(where: { club in
            club.name == self.club?.clubName })
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
    
    func triggerClubListeners() {
        clubRepository.listenForChanges(for: club!.id) { [weak self] club in
            guard let self = self else {
                print("Unable to update club")
                return
            }
            self.club = club
        }
    }
    
    func triggerRequestListeners() {
        clubRepository.listenForRequestChanges(for: club!.clubName) { [weak self] requests in
            guard let self = self else {
                print("Unable to update userRequests")
                return
            }
            self.userRequests = requests
        }
    }
    
    func fetchData(for clubID: String) async throws {
        let fetchedClub = try await clubRepository.getClub(clubId: clubID)
        Task {
            await MainActor.run {
                self.club = fetchedClub
                self.state = .club(fetchedClub)
                triggerClubListeners()
                triggerRequestListeners()
            }
        }
    }
    //Here
    func fetchWorkouts() {
        Task {
            do {
                let (fetchedWorkouts, lastDocument) = try await clubRepository.getWorkouts(for: self.club!.clubName, lastDocument: lastDocument, history: isHistory)
                await MainActor.run {
                    for workout in fetchedWorkouts {
                        if !self.workouts.contains(where: { $0 == workout }) {
                            self.workouts.append(workout)
                        }
                    }
                    if let lastDocument {
                        self.lastDocument = lastDocument
                    }
                    getUniqueDates(isHistory: isHistory)
                    isTaskInProgress = false
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }

    func deleteWorkout(at offsets: IndexSet) {
        let deletedWorkouts = offsets.map { workouts[$0] }
        
        for deletedWorkout in deletedWorkouts {
            do {
                try clubRepository.deleteWorkout(for: self.club!.clubName, with: deletedWorkout.workoutId)
            } catch {
                print("Error deleting workout: \(error)")
            }
        }
    }
    
    func removeMember(at offsets: IndexSet) {
        let membersToRemove = offsets.map { club!.members[$0] }
        
        for member in membersToRemove {
            do {
                try clubRepository.remove(user: member, from: self.club!)
            } catch {
                print("Error removing user from club: \(error)")
            }
        }
    }
    
    func sendJoinRequest(for clubId: String, request: ClubRequestModel) throws {
        try clubRepository.sendJoinRequest(for: clubId, from: request.userID, with: request.userName)
    }
    
    func accept(request: ClubRequestModel) throws {
        try clubRepository.accept(request: request, from: club!)
        let index = userRequests.firstIndex(where: {newRequest in newRequest.requestID == request.requestID})!
        userRequests[index].status = RequestStatus.accepted.rawValue
        userRequests.remove(at: index)
    }
    
    func reject(request: ClubRequestModel) throws {
        try clubRepository.reject(request: request, from: club!)
        let index = userRequests.firstIndex(where: {newRequest in newRequest.requestID == request.requestID})!
        userRequests.remove(at: index)
    }

    func updateClubPicture() {
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
            try clubRepository.updateClubPicture(clubID: club.clubName, pictureUrl: url.absoluteString)
        }
    }
}

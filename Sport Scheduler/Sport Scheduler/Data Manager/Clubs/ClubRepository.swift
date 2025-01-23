//
//  Club Repository.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 8.01.24.
//

import Foundation
@preconcurrency import FirebaseFirestore

protocol ClubRepository: Sendable {
    func create(club: Club) async throws
    func getClub(clubId: String) async throws -> Club
    func add(workout: Workout, for clubId: String) async throws
    func add(participant: ClubUserModel, for workout: Workout, from club: Club) async throws
    func getWorkouts(for club: String, lastDocument: DocumentSnapshot?, history: Bool) async throws -> ([Workout], lastDocument: DocumentSnapshot?)
    func deleteWorkout(for clubId: String, with workoutId: String) async throws
    func updateWorkout(for clubId: String, with workout: Workout) async throws
    func sendJoinRequest(for clubId: String, from userId: String, with name: String) async throws
    func getRequests(for clubId: String) async throws -> [ClubRequestModel]
    func accept(request: ClubRequestModel, from club: Club) async throws
    func reject(request: ClubRequestModel, from club: Club) async throws
    func remove(user: ClubUserModel, from club: Club) async throws
    func listenForChanges(for club: String) async throws -> AsyncThrowingStream<Club, Error>
    func listenForClubChanges() async throws -> AsyncThrowingStream<[Club], Error>
    func listenForRequestChanges(for club: String) async throws -> AsyncThrowingStream<[ClubRequestModel], Error>
    func updateClubPicture(clubID: String, pictureUrl: String) async throws
}

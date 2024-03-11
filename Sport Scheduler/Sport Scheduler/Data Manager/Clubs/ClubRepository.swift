//
//  Club Repository.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 8.01.24.
//

import Foundation

protocol ClubRepository {
    func create(club: Club) async throws
    func getClub(clubId: String) async throws -> Club
    func add(workout: Workout, for clubId: String) throws
    func add(participant: ClubUserModel, for workout: Workout) throws
    func getWorkouts(for clubId: String, on date: Date) async throws -> [Workout]
    func getAllWokrouts(for user: DBUser, on date: Date) async throws -> [Workout]
    func deleteWorkout(for clubId: String, with workoutId: String) throws
    func updateWorkout(for clubId: String, with workout: Workout) throws
    func sendJoinRequest(for clubId: String, from userId: String, with name: String) throws
    func getRequests(for clubId: String) async throws -> [ClubRequestModel]
    func accept(request: ClubRequestModel, from club: Club) throws
    func reject(request: ClubRequestModel, from club: Club) throws
    func listenForClubChanges(onSuccess: @escaping ([Club]) -> Void)
    func listenForRequestChanges(for club: String, onSuccess: @escaping ([ClubRequestModel]) -> Void)
}

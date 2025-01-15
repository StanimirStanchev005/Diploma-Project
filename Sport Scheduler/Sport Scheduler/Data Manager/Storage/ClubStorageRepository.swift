//
//  ClubStorageRepository.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 5.04.24.
//

import Foundation
import UIKit

protocol ClubStorageRepository {
    func saveImage(data: Data, name: String) async throws -> (path: String, name: String)
    func getUrlFromImage(path: String) async throws -> URL 
}

//
//  FirebaseClubStorageRepository.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 5.04.24.
//

import Foundation
import FirebaseStorage

final class FirebaseClubStorageRepository: ClubStorageRepository {
    
    private let storage = Storage.storage().reference()
   
    func saveImage(data: Data, name: String) async throws -> (path: String, name: String) {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        let path = "\(name).jpeg"
        let returnedMetaData = try await storage.child(name).child(path).putDataAsync(data, metadata: meta)
        
        guard let returnedPath = returnedMetaData.path, let returnedName = returnedMetaData.name else {
            throw URLError(.badServerResponse)
        }
        
        return (returnedPath, returnedName)
    }
    
    func getUrlFromImage(path: String) async throws -> URL {
        try await Storage.storage().reference(withPath: path).downloadURL()
    }
}

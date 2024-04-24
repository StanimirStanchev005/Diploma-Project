//
//  CacheManager.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 24.04.24.
//

import SwiftUI

final class CacheManager {
    static let shared = CacheManager()
    private init() { }

    var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024  * 1024 * 512
        return cache
    }()

    func add(image: UIImage, name: String) {
        imageCache.setObject(image, forKey: name as NSString)
        print("Added to cache")
    }
    func remove(name: String) {
        imageCache.removeObject(forKey: name as NSString)
        print("Removed from cache")
    }

    func get(name: String) -> UIImage? {
        imageCache.object(forKey: name as NSString)
    }
}

//
//  ImageCacheExtension.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 25.04.24.
//

import Foundation

extension URLCache {

    static let imageCache = URLCache(memoryCapacity: 512*1000*1000, diskCapacity: 10*1000*1000*1000)
}

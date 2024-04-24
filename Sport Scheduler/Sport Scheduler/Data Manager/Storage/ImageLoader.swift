//
//  ImageLoader.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 24.04.24.
//

import SwiftUI

final class ImageLoader: ObservableObject {
    let url: String?

    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false

    init(url: String?) {
        self.url = url
    }

    func fetch(club: String) {
        guard image == nil && !isLoading else {
            return
        }

        guard let url = url, let fetchURL = URL(string: url) else {
            hasError = true
            return
        }
        isLoading = true
        hasError = false

        if let imageFromCache = CacheManager.shared.get(name: club) {
            self.image = imageFromCache
            return
        }

        let task = URLSession.shared.dataTask(with: fetchURL) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let data = data, let image = UIImage(data: data) {
                    self?.image = image
                    CacheManager.shared.add(image: image, name: club)
                } else {
                    self?.hasError = true
                }
            }
        }

        task.resume()
    }
}

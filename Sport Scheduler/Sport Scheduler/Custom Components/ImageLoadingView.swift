//
//  ImageLoadingView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 24.04.24.
//

import SwiftUI

struct ImageLoadingView: View {
    @StateObject var imageLoader: ImageLoader
    let club: String

    init(url: String?, club: String) {
        self._imageLoader = StateObject(wrappedValue: ImageLoader(url: url))
        self.club = club
    }
    var body: some View {
        Group {
            if imageLoader.image != nil {
                Image(uiImage: imageLoader.image!)
                    .resizable()
                    .frame(width: 100)
                    .clipShape(Circle())
                    .frame(width: 100, height: 100)
                    .padding()
            } else if imageLoader.hasError {
                Image(systemName: "person.3.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.lightBackground)
                    .frame(width: 100, height: 100)
                    .padding()
            } else {
                ProgressView()
                    .controlSize(.large)
                    .frame(width: 100, height: 100)
            }
        }
        .onAppear {
            imageLoader.fetch(club: club)
        }
    }
}

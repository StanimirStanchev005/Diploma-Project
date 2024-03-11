//
//  SplashView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 4.01.24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Text("Welcome to SportScheduler")
                .font(.title)
            Text("Have all your workouts at one place")
                .font(.headline)
        }
    }
}

#Preview {
    LoadingView()
}

//
//  SplashView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 4.01.24.
//

import SwiftUI

struct SplashView: View {
    
    var body: some View {
        VStack {
            Image("SplashViewIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            Text("Welcome to SportScheduler")
                .font(.headline)
            Text("Have all your workouts at one place")
                .font(.subheadline)
        }
    }
}

#Preview {
    SplashView()
}

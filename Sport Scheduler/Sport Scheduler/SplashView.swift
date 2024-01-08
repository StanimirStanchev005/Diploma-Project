//
//  SplashView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 4.01.24.
//

import SwiftUI

struct SplashView: View {
    @State private var opacity = 0.5
    @State private var size = 0.8
    
    var body: some View {
        VStack {
            Image("SplashScreenIcon")
                .resizable()
                .frame(width: 200, height: 200)
        }
        .scaleEffect(size)
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeIn(duration: 1.2)) {
                self.size = 0.9
                self.opacity = 1
            }
        }
    }
}

#Preview {
    SplashView()
}

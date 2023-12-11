//
//  ContentView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 7.12.23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        VStack {
            if viewModel.isSignedInAndSynced {
                MainView()
            } else {
                WelcomeView()
            }
            
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}

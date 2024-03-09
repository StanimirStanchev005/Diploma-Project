//
//  Sport_SchedulerApp.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 7.12.23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

@main
struct Sport_SchedulerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var user: CurrentUser = CurrentUser()
        
    var body: some Scene {
        WindowGroup {
            
            ContentView()
                .environmentObject(user)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
        
    }
    
}

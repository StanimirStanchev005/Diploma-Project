//
//  ContentViewModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 2.03.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class ContentViewModel: ObservableObject {
    private var authenticationProvider: AuthenticationServiceProvidable
    private var userRepository: UserRepository
    @Published var showSplashView = true
    
    init(authenticationProvider: AuthenticationServiceProvidable = FirebaseAuthenticationProvider(), userRepository: UserRepository = FirestoreUserRepository()) {
        self.authenticationProvider = authenticationProvider
        self.userRepository = userRepository
    }
    
    @MainActor
    func checkUser(currentUser: CurrentUser) async {
        do {
            let authUser: AuthDataResultModel? = try authenticationProvider.getAuthenticatedUser()
            guard authUser != nil else {
                currentUser.showSignInView = true
                return
            }
            currentUser.user = try await userRepository.getUser(userId: authUser!.uid)
            showSplashView = false
        } catch {
            currentUser.showSignInView = true
        }
        showSplashView = false
    }
    
}


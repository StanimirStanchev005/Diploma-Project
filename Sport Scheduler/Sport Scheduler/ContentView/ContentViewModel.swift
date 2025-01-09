//
//  ContentViewModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 2.03.24.
//

import FirebaseAuth
import FirebaseFirestore

enum ContentViewScreenState {
    case loading
    case noUser
    case hasUser
}

@Observable
final class ContentViewModel {
    private let authenticationProvider: AuthenticationServiceProvidable
    private let userRepository: UserRepository
    var showSplashView = true
    
    init(authenticationProvider: AuthenticationServiceProvidable = FirebaseAuthenticationProvider(), userRepository: UserRepository = FirestoreUserRepository()) {
        self.authenticationProvider = authenticationProvider
        self.userRepository = userRepository
    }
    
    @MainActor
    func checkUser(currentUser: CurrentUser) async {
        do {
            let authUser: AuthDataResultModel? = try authenticationProvider.getAuthenticatedUser()
            guard authUser != nil else {
                currentUser.state = .noUser
                return
            }
            currentUser.user = try await userRepository.getUser(userId: authUser!.uid)
            currentUser.state = .hasUser
        } catch {
            currentUser.state = .noUser
        }
    }
    
}


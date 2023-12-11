//
//  AppViewModel.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 11.12.23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class AppViewModel: ObservableObject {
    @Published var user: User?
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    var uuid: String? {
        auth.currentUser?.uid
    }
    
    var isSignedIn: Bool {
        auth.currentUser != nil
    }
    
    var isSignedInAndSynced: Bool {
        user != nil && isSignedIn
    }
    
    func register(name: String, email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self?.add(User(name: name))
                self?.sync()
            }
        }
    }
    
    func login(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self?.sync()
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch {
            print("Error signing out user: \(error)")
        }
        
    }
    
    private func sync() {
        guard isSignedIn else { return }
        db.collection("users").document(self.uuid!).getDocument { (document, error) in
            guard document != nil, error == nil else { return }
            do {
                try self.user = document!.data(as: User.self)
            } catch {
                print("Sync error \(error)")
            }
        }
    }
    
    private func add(_ user: User) {
        guard isSignedIn else { return }
        do {
            let _ = try db.collection("users").document(self.uuid!).setData(from: user)
        } catch {
            print("Error adding: \(error)")
        }
    }
    
    private func update() {
        guard isSignedIn else { return }
        do {
            let _ = try db.collection("users").document(self.uuid!).setData(from: user)
        } catch {
            print("Error updating: \(error)")
        }
    }
}

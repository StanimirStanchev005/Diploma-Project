//
//  ClubView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 10.12.23.
//

import SwiftUI

import FirebaseFirestore

final class ClubModel: ObservableObject {
    private var clubRepository: ClubRepository
    private var userRepository: UserRepository
    
    @Published var club: Club?
    
    init(clubRepository: ClubRepository = Firestore.firestore(),
         userRepository: UserRepository = Firestore.firestore()) {
        self.clubRepository = clubRepository
        self.userRepository = userRepository
    }
    
    func fetchData(for clubId: String) async throws {
        let fetchedClub = try await clubRepository.getClub(clubId: clubId)
        
        Task {
            await MainActor.run {
                self.club = fetchedClub
            }
        }
        
    }
    
}

struct ClubView: View {
    @State private var showAddWorkoutScreen = false
    @StateObject private var clubModel = ClubModel()
    @EnvironmentObject var currentUser: CurrentUser
    
    let club: UserClubModel
    
    var body: some View {
        ZStack {
            if clubModel.club == nil {
                ProgressView()
                    .controlSize(.large)
            } else {
                VStack(spacing: 10) {
                    Image(clubModel.club!.picture)
                        .resizable()
                        .frame(width: 100)
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                        .padding()
                    
                    Text("Members: \(clubModel.club!.members.count)")
                        .font(.headline)
                    
                    Text(clubModel.club!.description)
                        .font(.title3)
                        .padding([.leading, .trailing], 15)
                    
                    Divider()
                    
                    Spacer()
                    
                }
                .sheet(isPresented: $showAddWorkoutScreen) {
                    AddWorkoutView()
                }
                .navigationTitle(clubModel.club!.clubName)
                .toolbar {
                    Button {
                        showAddWorkoutScreen.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .task {
            do {
                try await clubModel.fetchData(for: club.name)
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ClubView(club: UserClubModel(name: "Sofia City breakers", picture: "ClubPlaceholder"))
    }
}

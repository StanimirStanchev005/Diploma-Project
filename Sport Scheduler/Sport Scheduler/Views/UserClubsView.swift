//
//  UserClubsView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 7.12.23.
//

import SwiftUI

struct UserClubsView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                Section("Joined") {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewModel.user!.joinedClubs) { club in
                                NavigationLink(value: club) {
                                    VStack {
                                        Image(club.picture)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                            .padding()
                                        VStack {
                                            Text(club.name)
                                                .font(.headline)
                                                .foregroundStyle(.white)
                                            Text("Members: \(club.members.count)")
                                                .font(.headline)
                                                .foregroundStyle(.gray)
                                        }
                                        .padding(.vertical)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.cyan)
                                    }
                                    .clipShape(.rect(cornerRadius: 10))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.black)
                                    }
                                }
                                .navigationDestination(for: Club.self) {_ in
                                    ClubView(club: club)
                                }
                            }
                        }
                        .frame(height: 220)
                        .padding(.horizontal)
                    }
                }
                Section("Owned") {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewModel.user!.ownedClubs) { club in
                                NavigationLink(value: club) {
                                    VStack {
                                        Image(club.picture)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                            .padding()
                                        VStack {
                                            Text(club.name)
                                                .font(.headline)
                                                .foregroundStyle(.white)
                                            Text("Members: \(club.members.count)")
                                                .font(.headline)
                                                .foregroundStyle(.gray)
                                        }
                                        .padding(.vertical)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.cyan)
                                    }
                                    .clipShape(.rect(cornerRadius: 10))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.black)
                                    }
                                }
                                .navigationDestination(for: Club.self) {_ in
                                    ClubView(club: club)
                                }
                            }
                        }
                        .frame(height: 220)
                        .padding(.horizontal)
                    }
                }
                Button("Add Clubs") {
                    viewModel.user!.joinedClubs.append(Club(name: "Gym"))
                    viewModel.user!.joinedClubs.append(Club(name: "Tennis Club"))
                    viewModel.user!.ownedClubs.append(Club(name: "Gym"))
                    viewModel.user!.ownedClubs.append(Club(name: "Tennis Club"))
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("My Clubs")
        }
    }
}

#Preview {
    UserClubsView()
}

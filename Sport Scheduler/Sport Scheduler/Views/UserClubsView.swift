//
//  UserClubsView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 7.12.23.
//

import SwiftUI

struct UserClubsView: View {
    @State private var exampleUser = UserModel(name: "Spas")
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                Section("Joined") {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(exampleUser.joinedClubs) { club in
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
                            ForEach(exampleUser.ownedClubs) { club in
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
                    exampleUser.joinedClubs.append(Club(name: "Gym"))
                    exampleUser.joinedClubs.append(Club(name: "Tennis Club"))
                    exampleUser.ownedClubs.append(Club(name: "Gym"))
                    exampleUser.ownedClubs.append(Club(name: "Tennis Club"))
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

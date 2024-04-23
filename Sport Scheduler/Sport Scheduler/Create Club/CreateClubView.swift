//
//  CreateClubView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 2.01.24.
//

import SwiftUI
import PhotosUI

struct CreateClubView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var currentUser: CurrentUser
    @StateObject private var createClubModel = CreateClubModel()
    @State private var showTermsOfService = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { _ in
                ZStack {
                    VStack(spacing: 15) {

                        PhotosPicker(selection: $createClubModel.selectedItem, matching: .images, photoLibrary: .shared()) {
                            switch createClubModel.imageState {
                            case .empty:
                                Image(systemName: "person.3.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.lightBackground)
                                    .frame(width: 120, height: 120)
                            case .loading:
                                ProgressView()
                                    .controlSize(.large)
                                    .frame(width: 120, height: 120)
                            case .success:
                                createClubModel.photo
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 120, height: 120)
                            }

                        }


                        LabeledTextField(input: $createClubModel.name, text: "Club name")
                        LabeledTextField(input: $createClubModel.description, text: "Description")

                        HStack{
                            Text("Select sport")

                            Spacer()

                            Picker("Sport", selection: $createClubModel.selectedSport) {
                                ForEach(createClubModel.sports, id: \.self) { sport in
                                    Text(sport)
                                }
                            }
                            .pickerStyle(.menu)
                        }

                        HStack {
                            Button("Terms of service") {
                                showTermsOfService.toggle()
                            }

                            Toggle("", isOn: $createClubModel.isValidRepresenter)
                                .toggleStyle(.switch)
                                .tint(.blue)
                        }

                        Button {
                            let club = Club(clubName: createClubModel.name, description: createClubModel.description, category: createClubModel.selectedSport, ownerId: currentUser.user!.userID)
                            createClubModel.create(club: club, for: currentUser.user!.userID, photo: createClubModel.selectedItem)
                        } label: {
                            SignInButton(text: "Create", color: createClubModel.isInputValid ? .blue : .gray)
                        }
                        .disabled(createClubModel.isInputValid == false)
                        .padding(.vertical, 20)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)

                    if createClubModel.isTaskInProgress {
                        ProgressView()
                            .controlSize(.large)
                    }
                }
                .navigationTitle("Create Club")
                .navigationBarTitleDisplayMode(.inline)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading){
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .padding()
        .alert("Error", isPresented: $createClubModel.hasError) {
            Button("OK") {
                createClubModel.hasError = false
            }
        } message: {
            Text(createClubModel.localizedError)
        }
        
        .alert("Success", isPresented: $createClubModel.clubCreationSuccess) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Congrats! Club was created successfully")
        }
        
        .sheet(isPresented: $showTermsOfService) {
            TermsOfServiceView()
                .presentationDetents([.medium])
        }
        .onChange(of: createClubModel.selectedItem)  {
            createClubModel.convertDataToImage()
        }
    }
}

#Preview {
    CreateClubView()
}

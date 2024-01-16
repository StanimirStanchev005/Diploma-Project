//
//  CreateClubView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 2.01.24.
//

import SwiftUI

struct CreateClubView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var currentUser: CurrentUser
    @StateObject private var createClubModel = CreateClubModel()
    @State private var showTermsOfService = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                
                Image("ClubPlaceholder")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 300)
                
                Spacer()
                
                VStack(spacing: 15) {
                    
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
                            .tint(.pink)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button {
                    Task {
                        let club = Club(clubName: createClubModel.name, description: createClubModel.description, category: createClubModel.selectedSport, ownerId: currentUser.user!.userID)
                        
                        try await createClubModel.create(club: club, for: currentUser.user!)
                        
                        guard createClubModel.hasError == false else {
                            return
                        }
                        
                        dismiss()
                    }
                } label: {
                    SignInButton(text: "Create", color: createClubModel.isInputValid ? .pink : .gray)
                }
                .disabled(createClubModel.isInputValid == false)
                .padding()
            }
        }
        .padding()
        .alert("Error", isPresented: $createClubModel.hasError) {
            Button("OK") {
                createClubModel.hasError = false
            }
        } message: {
            Text(createClubModel.localizedError)
        }
        .sheet(isPresented: $showTermsOfService) {
            TermsOfServiceView()
                .presentationDetents([.medium])
        }
        .navigationTitle("Create Club")
    }
}

#Preview {
    CreateClubView()
}

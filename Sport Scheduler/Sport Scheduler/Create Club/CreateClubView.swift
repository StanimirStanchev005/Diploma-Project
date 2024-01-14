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
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 5) {
                    HStack {
                        Text("Create Club")
                            .font(.largeTitle)
                            .foregroundStyle(.lightBackground)
                        
                        Spacer()
                        
                        Button(role: .destructive) {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle")
                                .imageScale(.large)
                                .foregroundStyle(.lightBackground)
                        }
                    }
                    
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
                            NavigationLink("Terms of service") {
                                Text("I verify that I am an authorized representative of this organization and have the right to act on its behalf in the creation and management of this page. The organization and I agree to the additional terms for Pages.")
                                    .font(.title3)
                                    .padding()
                            }
                            
                            Toggle("", isOn: $createClubModel.isValidRepresenter)
                                .toggleStyle(.switch)
                                .tint(.pink)
                        }
                    }
                    .padding(.horizontal)
                }
                
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
    }
}

#Preview {
    CreateClubView()
}

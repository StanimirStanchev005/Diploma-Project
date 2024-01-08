//
//  CreateClubView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 2.01.24.
//

import SwiftUI

class CreateClubModel: ObservableObject {
    @Published var sports = ["Archery", "Athletics", "Badminton", "Basketball", "Boxing", "BreakDance", "Canoeing", "Cycling", "Diving", "Equestrian", "Fencing", "Football", "Golf", "Gymnastics", "Handball", "Hockey", "Judo", "Modern Pentathlon", "Rowing", "Rugby Sevens", "Sailing", "Shooting", "Swimming", "Synchronized Swimming", "Table Tennis", "Taekwondo", "Tennis", "Triathlon", "Volleyball", "Water Polo", "Weightlifting", "Wrestling"]
    @Published var name = ""
    @Published var description = ""
    @Published var isValidRepresenter = false
    @Published var selectedSport: String = "Football"
    
    var isInputValid: Bool {
        isValidRepresenter && !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

struct CreateClubView: View {
    @Environment(\.dismiss) var dismiss
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
                    
                } label: {
                    SignInButton(text: "Create", color: createClubModel.isInputValid ? .pink : .gray)
                }
                .disabled(createClubModel.isInputValid == false)
                .padding()
            }
        }
        .padding()
    }
}

#Preview {
    CreateClubView()
}

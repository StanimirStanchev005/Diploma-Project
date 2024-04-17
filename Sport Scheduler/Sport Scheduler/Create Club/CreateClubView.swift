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
            ZStack {
                VStack(spacing: 15) {
                    
                    PhotosPicker(selection: $createClubModel.selectedItem, matching: .images, photoLibrary: .shared()) {
                        createClubModel.photo
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 120, height: 120)
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
                            .tint(.pink)
                    }
                    
                    Button {
                        let club = Club(clubName: createClubModel.name, description: createClubModel.description, category: createClubModel.selectedSport, ownerId: currentUser.user!.userID)
                        createClubModel.create(club: club, for: currentUser.user!.userID, photo: createClubModel.selectedItem)
                    } label: {
                        SignInButton(text: "Create", color: createClubModel.isInputValid ? .pink : .gray)
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
            .modifier(OverflowContentViewModifier())
            .navigationTitle("Create Club")
            .navigationBarTitleDisplayMode(.inline)
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

extension View { //Add this View extension
    @ViewBuilder
    func wrappedInScrollView(when condition: Bool) -> some View {
        if condition {
            ScrollView(showsIndicators: false, content: {
                self
            })
        } else {
            self
        }
    }
}

struct OverflowContentViewModifier: ViewModifier {
    @State private var contentOverflow: Bool = false

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
            .background(
                GeometryReader { contentGeometry in
                    Color.clear.onAppear {
                        contentOverflow = contentGeometry.size.height > geometry.size.height
                    }
                }
            )
            .wrappedInScrollView(when: contentOverflow)
        }
    }
 }

#Preview {
    CreateClubView()
}

//
//  ClubRequestsView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 18.02.24.
//

import SwiftUI


struct ClubRequestsView: View {
    @EnvironmentObject var currentUser: CurrentUser
    @ObservedObject var clubModel: ClubModel
    
    var body: some View {
        VStack {
            List {
                ForEach(clubModel.userRequests.filter { $0.status == RequestStatus.pending.rawValue }, id: \.self.requestID) { request in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(request.userName)
                            Text(request.date.formatted())
                        }
                        Spacer()
                        
                        Button() {
                            do {
                                try clubModel.accept(request: request)
                                print("Accepted")
                            } catch {
                                print("Error accepting join request \(error)")
                            }
                        } label: {
                            VStack {
                                Image(systemName: "checkmark")
                                Text("Accept")
                            }
                            .foregroundStyle(.green)
                        }
                        .buttonStyle(.borderless)
                        
                        Button(role: .destructive) {
                            do {
                                try clubModel.reject(request: request)
                                print("Rejected")
                            } catch {
                                print("Error rejecting request: \(error)")
                            }
                        } label: {
                            VStack {
                                Image(systemName: "xmark")
                                Text("Reject")
                            }
                            .foregroundStyle(.red)
                        }
                        .buttonStyle(.borderless)
                        .padding(.horizontal, 5)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Requests")
        }
    }
}

#Preview {
    ClubRequestsView(clubModel: ClubModel())
        .environmentObject(CurrentUser())
}

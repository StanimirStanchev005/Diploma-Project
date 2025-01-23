//
//  ClubRequestsView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 18.02.24.
//

import SwiftUI


struct ClubRequestsView: View {
    @Environment(CurrentUser.self) private var currentUser: CurrentUser
    @Binding var clubModel: ClubModel

    var body: some View {
        VStack {
            List {
                if clubModel.userRequests.isEmpty {
                    ContentUnavailableView("No one wants to join your club", systemImage: "person.crop.circle.badge.xmark.fill")
                }
                ForEach(clubModel.userRequests.filter { $0.status == RequestStatus.pending.rawValue }, id: \.self.requestID) { request in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(request.userName)
                            Text(request.date.formatted())
                        }
                        Spacer()

                        Button {
                            clubModel.accept(request: request)
                        } label: {
                            VStack {
                                Image(systemName: "checkmark")
                                Text("Accept")
                            }
                            .foregroundStyle(.green)
                        }
                        .buttonStyle(.borderless)

                        Button(role: .destructive) {
                            clubModel.reject(request: request)
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
    ClubRequestsView(clubModel: .constant(ClubModel()))
        .environment(CurrentUser())
}

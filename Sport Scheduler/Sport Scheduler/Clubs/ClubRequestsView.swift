//
//  ClubRequestsView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 18.02.24.
//

import SwiftUI


struct ClubRequestsView: View {
    @EnvironmentObject var currentUser: CurrentUser
    @StateObject var clubModel: ClubModel
    
    
    var body: some View {
        VStack {
            List {
                ForEach(clubModel.userRequests, id: \.self.requestID) { request in
                    VStack(alignment: .leading) {
                        Text(request.userName)
                        Text(request.date.formatted())
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Requests")
        }
        .task {
            do {
                try await clubModel.getRequests()
            } catch {
                print("Error fetching user requests: \(error)")
            }
        }
    }
}

#Preview {
    ClubRequestsView(clubModel: ClubModel())
}

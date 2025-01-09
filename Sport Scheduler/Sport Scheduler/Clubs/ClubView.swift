//
//  ClubView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 10.12.23.
//

import SwiftUI

struct ClubView: View {
    @State var clubModel = ClubModel()
    @Environment(CurrentUser.self) private var currentUser: CurrentUser

    let club: UserClubModel
    
    var body: some View {
        ZStack {
            switch clubModel.state {
            case .loading:
                VStack {
                    ProgressView()
                        .controlSize(.large)
                    Text("Loading...")
                }
            case .club:
                ClubContentView(clubModel: $clubModel)
            }
        }
        .task {
            do {
                try await clubModel.fetchData(for: club.name)
            } catch {
                print("Error fetching club: \(error)")
            }
        }
    }
}

#Preview {
    NavigationStack {
       Text("Will add previews later")
    }
}

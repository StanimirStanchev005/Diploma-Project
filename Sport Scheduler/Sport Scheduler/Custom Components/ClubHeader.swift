//
//  ClubHeader.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 18.02.24.
//

import SwiftUI

struct ClubHeader: View {
    @ObservedObject var clubModel: ClubModel
    let isOwner: Bool
    let isJoined: Bool
    @Binding var selectedDate: Date
    
    init(clubModel: ClubModel, isOwner: Bool = false, isJoined: Bool = false, selectedDate: Binding<Date> = .constant(Date())) {
        self.clubModel = clubModel
        self.isOwner = isOwner
        self.isJoined = isJoined
        self._selectedDate = selectedDate
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Image(clubModel.club?.picture ?? "ClubPlaceholder")
                .resizable()
                .frame(width: 100)
                .clipShape(Circle())
                .frame(width: 100, height: 100)
                .padding()
            
            Text("Members: \(clubModel.club?.members.count ?? 0)")
                .font(.headline)
            
            Text(clubModel.club?.description ?? "")
                .multilineTextAlignment(.center)
                .font(.title3)
                .padding([.leading, .trailing], 15)
                .lineLimit(2)
                .truncationMode(.tail)
            
            if isOwner {
                HStack(spacing: 10) {
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                        .labelsHidden()
                    NavigationLink("Requests (\(clubModel.userRequests.count))", destination: ClubRequestsView(clubModel: clubModel))
                        .foregroundStyle(.lightBackground)
                        .tint(.gray.opacity(0.2))
                        .buttonStyle(.borderedProminent)
                        .frame(maxWidth: 130)
                    NavigationLink("Members", destination: ClubMembersView(clubModel: clubModel))
                        .foregroundStyle(.lightBackground)
                        .tint(.gray.opacity(0.2))
                        .buttonStyle(.borderedProminent)
                    
                }
                .padding(10)
            } else if isJoined {
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                    .labelsHidden()
                    .padding(10)
            }
            Divider()
                .padding(.vertical, 10)
        }
    }
}

#Preview {
    ClubHeader(clubModel: ClubModel(), isOwner: true)
}

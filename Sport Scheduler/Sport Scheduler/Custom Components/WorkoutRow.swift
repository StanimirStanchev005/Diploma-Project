//
//  WorkoutRow.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 23.01.24.
//

import SwiftUI

struct WorkoutRow: View {
    let title: String
    let description: String
    let participants: [Participants]
    let date: Date
    var body: some View {
        HStack {
            VStack {
                Text(title)
                    .font(.headline)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundStyle(.lightBackground)
                Text(description)
                    .font(.subheadline)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundStyle(.lightBackground)
            }
            
            Spacer()
            
            VStack {
                Text("Participants: \(participants.count)")
                    .foregroundStyle(.lightBackground)
                Text(date.formatted())
                    .foregroundStyle(.lightBackground)
            }
        }
    }
}

#Preview {
    WorkoutRow(title: "Example workout", description: "Some random text for example description", participants: [], date: Date())
}

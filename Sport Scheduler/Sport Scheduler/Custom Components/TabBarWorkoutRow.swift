//
//  TabBarWorkoutRow.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 28.02.24.
//

import SwiftUI

struct TabBarWorkoutRow: View {
    let title: String
    let description: String
    let club: String
    let date: Date
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .font(.subheadline)
            }
            VStack(alignment: .leading) {
                Text(club)
                    .font(.headline)
                Text(date.formatted(date: .omitted, time: .shortened))
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    TabBarWorkoutRow(title: "Title", description: "Descritpion for the current workout", club: "Sofia City Breakers", date: Date())
}

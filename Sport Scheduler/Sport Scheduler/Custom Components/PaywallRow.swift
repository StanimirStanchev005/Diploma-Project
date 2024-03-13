//
//  PaywallRow.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 13.03.24.
//

import SwiftUI

struct PaywallRow: View {
    let planTitle: String
    let planPrice: Double
    let planDescription: String
    @State var isChosen: Bool
    
    var body: some View {
        Button {
            isChosen.toggle()
        } label: {
            HStack {
                Text(planTitle)
                    .font(.title)
                    .bold()
                
                Spacer()
                
                VStack {
                    Text(planPrice, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .font(.headline)
                    Text(planDescription)
                        .font(.subheadline)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .frame(minWidth: 300)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    PaywallRow(planTitle: "Standard", planPrice: 0, planDescription: "No ability to create clubs", isChosen: false)
}

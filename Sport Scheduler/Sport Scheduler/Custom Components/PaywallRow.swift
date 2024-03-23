//
//  PaywallRow.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 13.03.24.
//

import SwiftUI

struct PaywallRow: View {
    let plan: PremiumPlan
    @Binding var isChosen: Bool
    @Binding var isAlertShown: Bool
    
    var body: some View {
        Button {
            isChosen.toggle()
            isAlertShown.toggle()
        } label: {
            HStack {
                Text(plan.title)
                    .font(.title)
                    .bold()
                
                Spacer()
                
                VStack {
                    Text(plan.price, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .font(.headline)
                    Text(plan.extras)
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
    PaywallRow(plan: PremiumPlan(tier: 0, title: "Gold", extras: "Some extras added", price: 50), isChosen: .constant(false), isAlertShown: .constant(false))
}

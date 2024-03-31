//
//  PlanDetailsView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 31.03.24.
//

import SwiftUI

struct PlanDetailsView: View {
    @Environment(\.dismiss) var dismiss
    let plan: PremiumPlan
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Plan Details")
                    .font(.custom("AmericanTypewriter", size: 34, relativeTo: .largeTitle))
                    .foregroundStyle(.lightBackground)
                
                Spacer()
                
                Button(role: .destructive) {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle")
                        .imageScale(.large)
                        .foregroundStyle(.blue)
                }
            }
            .padding(.bottom)
            Text(plan.title)
                .font(.custom("AmericanTypewriter-Bold", size: 28, relativeTo: .title))
                .padding(.bottom, 5)
            Text("Extras: \(plan.extras)")
                .font(.custom("AmericanTypewriter", size: 20, relativeTo: .title3))
                .padding(.bottom, 5)
            Text("Tier: \(plan.tier)\nPrice: \(plan.price, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                .font(.custom("AmericanTypewriter-Bold", size: 20, relativeTo: .title3))
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    PlanDetailsView(plan: PremiumPlan(tier: 3, title: "Title", extras: "asjbouboabdc boacbaos bcb ashu hjea piaspi js", price: 0))
}

//
//  Paywall.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 13.03.24.
//

import SwiftUI

struct Paywall: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var paywallModel = PaywallModel()
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Premium")
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
                
                Button(role: .destructive) {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle")
                        .imageScale(.large)
                        .foregroundStyle(.blue)
                }
            }
            Spacer()
            Image("PremiumIcon")
                .resizable()
                .scaledToFit()
            
            PaywallRow(planTitle: "Standard", planPrice: 0, planDescription: "No ability to create clubs", isChosen: paywallModel.isStandardChosen)
                .tint(.lightBackground)
            
            PaywallRow(planTitle: "Gold", planPrice: 49.99, planDescription: "Create up to 3 clubs", isChosen: paywallModel.isGoldChosen)
                .tint(.gold)
            
            PaywallRow(planTitle: "Diamond", planPrice: 99.99, planDescription: "Create unlimited clubs", isChosen: paywallModel.isDiamondChosen)
                .tint(.diamond)
        }
        .padding()
    }
}

#Preview {
    Paywall()
}

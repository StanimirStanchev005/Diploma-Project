//
//  Paywall.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 13.03.24.
//

import SwiftUI

struct Paywall: View {
    @EnvironmentObject var currentUser: CurrentUser
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
                .shadow(color: .white, radius: 10)
            
            PaywallRow(plan: Plans.standard.plan, isChosen: $paywallModel.isStandardChosen, isAlertShown: $paywallModel.isAlertShown)
                .shadow(color: .lightBackground, radius: 10)
                .tint(.lightBackground)
            
            PaywallRow(plan: Plans.gold.plan, isChosen: $paywallModel.isGoldChosen, isAlertShown: $paywallModel.isAlertShown)
                .shadow(color: .gold, radius: 10)
                .tint(.gold)
            
            PaywallRow(plan: Plans.diamond.plan, isChosen: $paywallModel.isDiamondChosen, isAlertShown: $paywallModel.isAlertShown)
                .shadow(color: .diamond, radius: 10)
                .tint(.diamond)
        }
        .padding()
       
        .alert(paywallModel.alertTitle, isPresented: $paywallModel.isAlertShown) {
            Button("Cancel") { 
                paywallModel.cancelUpgrade()
            }
            Button("OK") {
                paywallModel.alertFunction(currentUser.user)
            }
        } message: {
            Text(paywallModel.alertMessage)
        }
        
        .alert("Oops!", isPresented: $paywallModel.errorDowngradingPlan) {
            Button("OK") { }
        } message: {
            Text("It looks like you're trying to downgrade a plan or upgrade to the same plan you already have. You cannot do that.")
        }
        
        .alert("Success!", isPresented: $paywallModel.upgradeSuccess) {
            Button("OK") { 
                dismiss()
            }
        } message: {
            Text("You've successfully upgraded your plan. Enjoy creating clubs")
        }
    }
}

#Preview {
    Paywall()
}

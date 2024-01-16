//
//  TermsOfServiceView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 16.01.24.
//

import SwiftUI

struct TermsOfServiceView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Terms Of Service")
                    .font(.largeTitle)
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
            
            Text("I verify that I am an authorized representative of this organization and have the right to act on its behalf in the creation and management of this page. The organization and I agree to the additional terms for Pages.")
                .font(.title3)
                .foregroundStyle(.lightBackground)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    TermsOfServiceView()
}

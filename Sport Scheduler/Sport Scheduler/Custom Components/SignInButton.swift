//
//  SignInButton.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 7.12.23.
//

import SwiftUI

struct SignInButton: View {
    let text: String
    let color: Color
    
    var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(color)
                    .frame(maxWidth: 280, maxHeight: 60)
                
                Text(text)
                    .foregroundStyle(.white)
                    .font(.title3)
            }
        }
    }

#Preview {
    SignInButton(text: "", color: .black)
}

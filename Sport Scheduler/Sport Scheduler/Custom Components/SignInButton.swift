//
//  SignInButton.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 7.12.23.
//

import SwiftUI

struct SignInButton<TargetView: View>: View {
    let text: String
    let destination: TargetView
    let color: Color
    
    var body: some View {
        NavigationLink(destination: destination) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(color)
                    .frame(width: 280, height: 60)
                
                Text(text)
                    .foregroundStyle(.white)
                    .font(.title3)
            }
        }
    }
}

#Preview {
    SignInButton(text: "", destination: LoginView(), color: .black)
}

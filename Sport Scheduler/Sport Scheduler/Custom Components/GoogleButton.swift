//
//  GoogleButton.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 14.12.23.
//

import SwiftUI

struct GoogleButton: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke()
                }
            HStack {
                Image("GoogleIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 50)
                Text("Continue with Google")
                    .foregroundStyle(.black)
                    .font(.title3)
                
                Spacer()
            }
            .padding([.leading, .trailing], 5)
        }
        .frame(width: 280, height: 55)
    }
}

#Preview {
    GoogleButton()
}

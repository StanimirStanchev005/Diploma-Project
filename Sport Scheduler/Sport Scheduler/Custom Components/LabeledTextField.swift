//
//  LabeledTextField.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 4.01.24.
//

import SwiftUI

struct LabeledTextField: View {
    @Binding var input: String
    let text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.lightBackground)
            TextField(text, text: $input)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(Color.lightBackground, lineWidth: 1)
                )
                .overlay(
                    Button {
                        input = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .opacity(input.isEmpty ? 0 : 1)
                            .padding()
                            .foregroundStyle(.gray)
                    },
                    alignment: .trailing
                )
                .autocorrectionDisabled()
        }
    }
}

#Preview {
    LabeledTextField(input: .constant(""), text: "text")
}

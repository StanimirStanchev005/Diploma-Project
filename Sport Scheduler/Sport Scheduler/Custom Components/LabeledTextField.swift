//
//  LabeledTextField.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 7.12.23.
//

import SwiftUI

struct LabeledTextField: View {
    @Binding var input: String
    
    let text: String
    let isCapitalized: Bool
    let isSecure: Bool
    let isUserValid: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Group {
                if isSecure {
                    SecureField(text, text: $input)
                } else {
                    TextField(text, text: $input)
                }
            }
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 7)
                    .stroke(Color.secondary, lineWidth: 1)
            )
            .frame(width: 280, height: 50)
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
            .textInputAutocapitalization(isCapitalized ? .none : .never)
        }
        .frame(maxWidth: 280)
    }
}

#Preview {
    LabeledTextField(input: .constant(""), text: "text", isCapitalized: true, isSecure: false, isUserValid: false)
}

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
    let error: String
    let isCapitalized: Bool
    let isSecure: Bool
    let isUserValid: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .font(.subheadline)
            Group {
                if isSecure {
                    SecureField(text, text: $input)
                } else {
                    TextField(text, text: $input)
                }
            }
            .textFieldStyle(.roundedBorder)
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
            Text(error)
                .font(.subheadline)
                .foregroundStyle(.red)
                .opacity(isUserValid ? 0 : 1)
        }
        .frame(width: 240)
    }
}

#Preview {
    LabeledTextField(input: .constant(""), text: "text", error: "error", isCapitalized: true, isSecure: false, isUserValid: false)
}

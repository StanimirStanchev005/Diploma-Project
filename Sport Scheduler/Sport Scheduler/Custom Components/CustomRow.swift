//
//  CustomRow.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 20.01.24.
//

import SwiftUI

struct CustomRow: View {
    var label: String
    var placeholder: String
    @Binding var text: String

    var body: some View {
        HStack {
            Text(label)
            
            Spacer()
            
            TextField(placeholder, text: $text)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    CustomRow(label: "Name", placeholder: "Name", text: .constant(""))
}

//
//  TextErrorView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 9.12.23.
//

import SwiftUI

struct TextErrorView: View {
    var error: String
    var showingError: Bool
    
    var body: some View {
        Text(error)
            .font(.subheadline)
            .foregroundStyle(.red)
            .opacity(showingError ? 1 : 0)
            .frame(maxWidth: 280, alignment: .leading)
    }
}

#Preview {
    TextErrorView(error: "Some Error", showingError: true)
}

//
//  ClubHeader.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 18.02.24.
//

import SwiftUI

struct ClubHeader: View {
    let picture: String
    let members: Int
    let description: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(picture)
                .resizable()
                .frame(width: 100)
                .clipShape(Circle())
                .frame(width: 100, height: 100)
                .padding()
            
            Text("Members: \(members)")
                .font(.headline)
            
            Text(description)
                .font(.title3)
                .padding([.leading, .trailing], 15)
                .lineLimit(2)
                .truncationMode(.tail)
        }
    }
}

#Preview {
    ClubHeader(picture: "ClubPlaceholder", members: 0, description: "An example of long description to see how it will look on the compact screen of the phone, among the other components.")
}

//
//  ClubView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 10.12.23.
//

import SwiftUI

struct ClubView: View {
   let club: UserClubModel
    
    var body: some View {
        Text("Club \(club.name)")
    }
}

#Preview {
    ClubView(club: UserClubModel(name: "", picture: ""))
}

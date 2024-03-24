//
//  ClubMembersView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 24.03.24.
//

import SwiftUI

struct ClubMembersView: View {
    @EnvironmentObject var currentUser: CurrentUser
    @EnvironmentObject var clubModel: ClubModel
    
    var body: some View {
        List {
            ForEach(clubModel.club!.members, id: \.self.userID) { member in
                HStack {
                    Text(member.name)
                    Spacer()
                    Text("Workouts visited: \(member.visitedWorkouts)")
                }
            }
            .onDelete(perform: clubModel.removeMember)
        }
        .navigationTitle("Members")
    }
}

#Preview {
    let clubModel = ClubModel()
    clubModel.club = Club(clubName: "Levski", description: "xxxx", category: "Football", ownerId: "123")
    clubModel.club?.members.append(ClubUserModel(userID: "333", name: "Spas4o", visitedWorkouts: 3))
    let currentUser = CurrentUser()
    currentUser.user = DBUser(userID: "123", name: "Spas", email: "spas@mail.bg", photoUrl: "", dateCreated: Date())
    return ClubMembersView().environmentObject(currentUser) 
}

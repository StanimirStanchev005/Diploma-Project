//
//  ClubMembersView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 24.03.24.
//

import SwiftUI

final class ClubMembersModel: ObservableObject {
    @Published var members: [ClubUserModel] = []
    
    func sortMembersByName() {
        members.sort { $0.name < $1.name }
    }
    
    func sortMembersByWorkouts() {
        members.sort { $0.visitedWorkouts > $1.visitedWorkouts }
    }
}

struct ClubMembersView: View {
    @EnvironmentObject var currentUser: CurrentUser
    @EnvironmentObject var clubModel: ClubModel
    @StateObject var clubMembersModel = ClubMembersModel()
    
    var body: some View {
        List {
            ForEach(clubMembersModel.members, id: \.self.userID) { member in
                HStack {
                    Text(member.name)
                    Spacer()
                    Text("Workouts visited: \(member.visitedWorkouts)")
                }
            }
            .onDelete(perform: clubModel.removeMember)
        }
        .navigationTitle("Members")
        .toolbar {
            Menu {
                Button("Name") {
                    clubMembersModel.sortMembersByName()
                }
                Button("Workouts") {
                    clubMembersModel.sortMembersByWorkouts()
                }
            } label: {
                Label("Sort", systemImage: "line.3.horizontal.decrease.circle")
            }
        }
        .onAppear() {
            clubMembersModel.members = clubModel.club!.members
        }
        .onChange(of: clubModel.club!.members.count) {
            clubMembersModel.members = clubModel.club!.members
        }
    }
}

#Preview {
    let clubModel = ClubModel()
    clubModel.club = Club(clubName: "Levski", description: "xxxx", category: "Football", ownerId: "123")
    clubModel.club?.members.append(ClubUserModel(userID: "333", name: "Spas4o", visitedWorkouts: 3))
    let currentUser = CurrentUser()
    currentUser.user = DBUser(userID: "123", name: "Spas", email: "spas@mail.bg", photoUrl: "", dateCreated: Date())
    return NavigationStack { ClubMembersView().environmentObject(currentUser).environmentObject(clubModel) }
}

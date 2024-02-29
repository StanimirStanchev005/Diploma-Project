//
//  ProfileView.swift
//  Sport Scheduler
//
//  Created by Tumba Developer on 10.12.23.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct ProfileView: View {
    @StateObject private var profileModel = ProfileModel()
    @EnvironmentObject var currentUser: CurrentUser
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("* Use your QR Code to validate that you participated in a workout")
                    .font(.subheadline)
                    .padding()
                Spacer()
                
                ZStack {
                    LinearGradient(colors: [Color.gray.opacity(0.3), Color.black.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    Image(uiImage: generateQRCode(from: "\(currentUser.user!.userID)\n\(currentUser.user!.name)"))
                        .interpolation(.none)
                        .resizable()
                        .frame(width: 300, height: 300)
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .frame(width: 350, height: 350)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                
                
                Spacer()
            }
            .navigationTitle(currentUser.user!.name)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Sign Out") {
                        Task {
                            do {
                                try profileModel.signOut()
                                currentUser.showSignInView = true
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
            }
        }
    }
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
}


#Preview {
    NavigationStack {
        ProfileView().environmentObject({ () -> CurrentUser in
            let envObj = CurrentUser()
            envObj.user = DBUser(userID: "123", name: "Spas", email: "spas@mail.bg", photoUrl: "", dateCreated: Date())
            return envObj
        }())
    }
}

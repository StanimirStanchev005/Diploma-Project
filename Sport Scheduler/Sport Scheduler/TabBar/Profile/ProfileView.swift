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
                
                ZStack {
                    LinearGradient(colors: [Color.gold, Color.red.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    Image(uiImage: generateQRCode(from: "\(currentUser.user!.userID)\n\(currentUser.user!.name)"))
                        .interpolation(.none)
                        .resizable()
                        .frame(maxWidth: 300, maxHeight: 300)
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .frame(maxWidth: 320, maxHeight: 320)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                
                Button() {
                    
                } label: {
                    Text("Become Premium")
                        .frame(minWidth: 300, minHeight: 30)
                }
                .buttonStyle(.borderedProminent)
                .tint(.gold)
                .padding()
                
                Spacer()
            }
            
            .toolbar {
                Button("Sign Out", role: .destructive) {
                    Task {
                        do {
                            try profileModel.signOut()
                            withAnimation(.easeInOut) {
                                currentUser.showSignInView = true
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
                .tint(.red)
            }
            .navigationTitle(currentUser.user!.name)
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

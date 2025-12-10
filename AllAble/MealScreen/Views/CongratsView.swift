//
//  CongratsView.swift
//  AllAble
//
//  Created by Rana Alngashy on 12/06/1447 AH.
//

// CongratsView.swift
// CongratsView.swift


import SwiftUI

struct CongratsView: View {
    
    // MARK: - Navigation State
    // Required to trigger the hidden NavigationLink push to MainPage
    @AppStorage("selectedAvatarImageName") private var selectedAvatarImageName: String = "AvatarGirl"
    @State private var navigateToMainPage = false
    
    // MARK: - Properties
    let avatarType: String
    
    // Define the custom colors using standard syntax
    let customYellow = Color(red: 0.99, green: 0.85, blue: 0.33)
    let customBackground = Color(red: 0.97, green: 0.96, blue: 0.92)
    
    @Environment(\.horizontalSizeClass) private var hSize
    private var isCompact: Bool { true}     // iPhone
          var avatarImageName: String {
        // NOTE: These images must exist in your project's assets
        return avatarType == "male" ? "male_avatar_achievement" : "AvatarGirl"
    }
    
    var body: some View {
        VStack(spacing: 30) {
            
            // ————— HEADER —————
            Text("Title.Fantastic")
                .font(.system(size: isCompact ? 36 : 72, weight: .heavy))
                .foregroundColor(customYellow)
                .padding(.top, isCompact ? 40 : 80)
            
            Text("Message.DoseComplete")
                .font(isCompact ? .title3 : .title)
                .multilineTextAlignment(.center)
                .foregroundColor(.black.opacity(0.8))
                .padding(.horizontal, 20)
            
            Spacer()
            
            // ————— AVATAR IMAGE (Centered) —————
            Image(selectedAvatarImageName)
                .resizable()
                .scaledToFit()
                .frame(
                    width: isCompact ? 220 : 350,
                    height: isCompact ? 220 : 350
                )
                .clipShape(Circle())
                .overlay(Circle().stroke(customYellow, lineWidth: isCompact ? 5 : 8))
                .shadow(color: customYellow.opacity(0.4), radius: isCompact ? 8 : 15)
            
            Spacer()
            
            
            
            // 🛑 CRITICAL FIX: Reverting to the working NavigationLink structure
            // This link is pushed onto the stack after 2 seconds.
            NavigationLink(destination: MainPage().environmentObject(NotificationRouter()), isActive: $navigateToMainPage) {
                EmptyView()
            }
            .hidden()

            // REMOVED the "Done" button as requested
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(customBackground.ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear {
            Task {
                try await Task.sleep(nanoseconds: 2_000_000_000)
                navigateToMainPage = true
            }
        }
    }
}

#Preview {
    CongratsView(avatarType: "female")
        .environmentObject(NotificationRouter())
}

//
//  CongratsView.swift
//  AllAble
//
//  Created by Rana Alngashy on 12/06/1447 AH.
//

// CongratsView.swift
// CongratsView.swift
//
//  CongratsView.swift
//  AllAble
//
//  Created by Rana Alngashy on 12/06/1447 AH.
//

import SwiftUI

struct CongratsView: View {
    
    // MARK: - Environment
    // 1. Get the AppFlow to access the chosen avatar
    @EnvironmentObject var appFlow: AppFlowViewModel
    @EnvironmentObject var router: NotificationRouter
    
    // MARK: - Navigation State
    @State private var navigateToMainPage = false
    
    // MARK: - Properties
    // Removed 'let avatarType: String' because we fetch it from appFlow now
    
    // Define the custom colors using standard syntax
    let customYellow = Color(red: 0.99, green: 0.85, blue: 0.33)
    let customBackground = Color(red: 0.97, green: 0.96, blue: 0.92)
    
    var avatarImageName: String {
        // 2. Return the avatar name saved in the profile ("AvatarGirl" or "AvatarBoy")
        return appFlow.childProfile.avatarName
    }
    
    var body: some View {
        VStack(spacing: 30) {
            
            // ————— HEADER —————
            Text("Fantastic!")
                .font(.system(size: 60, weight: .heavy))
                .foregroundColor(customYellow)
                .shadow(radius: 5)
                .padding(.top, 80)
            
            Text("Dose complete! You managed your insulin like a pro.")
                .font(.title2)
                .multilineTextAlignment(.center)
                .foregroundColor(.black.opacity(0.8))
            
            Spacer()
            
            // ————— AVATAR IMAGE (Centered) —————
            Image(avatarImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 350)
                .clipShape(Circle())
                .overlay(Circle().stroke(customYellow, lineWidth: 8))
                .shadow(color: customYellow.opacity(0.5), radius: 15)
            
            Spacer()
            
            // 🛑 NAVIGATION 🛑
            // Pushes to MainPage after delay.
            // We pass 'appFlow' so MainPage knows which avatar to show too.
            NavigationLink(
                destination: MainPage()
                    .environmentObject(router)
                    .environmentObject(appFlow),
                isActive: $navigateToMainPage
            ) {
                EmptyView()
            }
            .hidden()

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(customBackground.ignoresSafeArea())
        .navigationBarHidden(true)
        
        // 2-second auto-navigation logic
        .onAppear {
            Task {
                try await Task.sleep(nanoseconds: 2_000_000_000)
                navigateToMainPage = true
            }
        }
    }
}

#Preview {
    // Inject mock data for the preview to work
    CongratsView()
        .environmentObject(NotificationRouter())
        .environmentObject(AppFlowViewModel())
}

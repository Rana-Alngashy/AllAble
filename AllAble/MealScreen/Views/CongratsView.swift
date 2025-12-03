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
    @State private var navigateToMainPage = false
    
    // MARK: - Properties
    let avatarType: String
    
    // Define the custom colors using standard syntax
    let customYellow = Color(red: 0.99, green: 0.85, blue: 0.33)
    let customBackground = Color(red: 0.97, green: 0.96, blue: 0.92)
    
    var avatarImageName: String {
        // NOTE: These images must exist in your project's assets
        return avatarType == "male" ? "male_avatar_achievement" : "AvatarGirl"
    }
    
    var body: some View {
        VStack(spacing: 30) {
            
            // ————— HEADER —————
            Text("Fantastic!")
                .font(.system(size: 60, weight: .heavy))
                .foregroundColor(customYellow) // Using custom yellow
                .shadow(radius: 5)
                .padding(.top, 80)
            
            Text("Dose complete! You managed your insulin like a pro.") // Final chosen message
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
        
        // 2-second auto-navigation logic (Working Method)
        .onAppear {
            Task {
                // Wait for 2 seconds (2,000,000,000 nanoseconds)
                try await Task.sleep(nanoseconds: 2_000_000_000)
                
                // Trigger the hidden NavigationLink push
                navigateToMainPage = true
            }
        }
    }
}
#Preview {
    CongratsView(avatarType: "female")
        .environmentObject(NotificationRouter()) 
}

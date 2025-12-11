//
//  OptionView.swift
//  AllAble
//
//  Created by Rana Alngashy on 12/06/1447 AH.
//
import SwiftUI

struct OptionView: View {
    
    @EnvironmentObject var router: NotificationRouter
    @EnvironmentObject var historyStore: HistoryStore
    @Environment(\.dismiss) private var dismiss // Helper to close view
    
    // MARK: - Navigation States
    @State private var navigateToTimerView = false
    @State private var goToHome = false // ⭐ Force Home Trigger
    
    // MARK: - Incoming Data
    var mealType: String = ""
    var mealName: String = ""
    var carbs: Double = 0.0
    var dose: Double = 0.0

    let customYellow = Color(red: 0.99, green: 0.85, blue: 0.33)
    let customBackground = Color(red: 0.97, green: 0.96, blue: 0.92)

    @Environment(\.horizontalSizeClass) private var hSize
    private var isCompact: Bool { true }
    
    var body: some View {
        VStack(spacing: isCompact ? 30 : 50) {
            
            Spacer()
            
            Text("Title.InsulinShot")
                .font(isCompact ? .title2 : .largeTitle)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.top, isCompact ? 40 : 50)
            
            
            // ————— YES, START TIMER BUTTON —————
            Button(action: {
                navigateToTimerView = true
            }) {
                Text("Button.YesTimer")
                    .font(isCompact ? .title3 : .title2)
                    .bold()
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, isCompact ? 18 : 25)
                    .background(customYellow)
                    .cornerRadius(14)
            }
            
            
            // ————— SKIP BUTTON (Go Home) —————
            Button(action: {
                // 1. Try to clear standard path
                router.navigationPath = NavigationPath()
                router.shouldNavigateToOptionView = false
                
                // 2. ⭐ Force Navigation to Home
                goToHome = true
                
            }) {
                Text("Button.Skip")
                    .font(isCompact ? .title3 : .title2)
                    .bold()
                    .foregroundColor(.black) // Changed from gray to black for visibility
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, isCompact ? 18 : 25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.black.opacity(1), lineWidth: 1.5)
                    )
            }
            
            Spacer()
        }
        .padding(.horizontal, isCompact ? 20 : 50)
        .background(customBackground.ignoresSafeArea())
        
        // ————— NAVIGATION —————
        
        // 1. To Timer
        .navigationDestination(isPresented: $navigateToTimerView) {
            TimerView(
                mealType: mealType,
                mealName: mealName,
                carbs: carbs,
                dose: dose
            )
        }
        
        // 2. ⭐ Force Go Home (The fix)
        .fullScreenCover(isPresented: $goToHome) {
            MainPage()
                .environmentObject(router)
                .environmentObject(historyStore)
        }
        
        .toolbarTitleDisplayMode(.inline)
        // If presented via sheet/cover, this helps remove it too
        .onChange(of: goToHome) { newValue in
            if newValue {
                // small delay to ensure UI updates before switching
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    router.shouldNavigateToOptionView = false
                }
            }
        }
    }
}

#Preview {
    OptionView()
        .environmentObject(NotificationRouter())
        .environmentObject(HistoryStore())
}

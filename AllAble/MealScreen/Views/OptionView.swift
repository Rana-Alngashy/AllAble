//
//  OptionView.swift
//  AllAble
//
//  Created by Rana Alngashy on 12/06/1447 AH.
//
import SwiftUI

struct OptionView: View {
    
    @EnvironmentObject var router: NotificationRouter
    
    @State private var navigateToReminderView = false
    @State private var navigateToTimerView = false
    @EnvironmentObject var historyStore: HistoryStore

    let customYellow = Color(red: 0.99, green: 0.85, blue: 0.33)
    let customBackground = Color(red: 0.97, green: 0.96, blue: 0.92)

    @Environment(\.horizontalSizeClass) private var hSize
    private var isCompact: Bool { true}  
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
            
            
            // ————— NO, SET REMINDER BUTTON —————
            Button(action: {
                navigateToReminderView = true     // <<⭐ الآن يفعل fullScreenCover
            }) {
                Text("Button.NoReminder")
                    .font(isCompact ? .title3 : .title2)
                    .bold()
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, isCompact ? 18 : 25)
                    .background(Color.white)
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
            
            Spacer()
        }
        .padding(.horizontal, isCompact ? 20 : 50)
        .background(customBackground.ignoresSafeArea())
        
        
        // ————— NAVIGATION DESTINATIONS —————
        
        .navigationDestination(isPresented: $navigateToTimerView) {
            TimerView()
        }
        
        
        // ⭐⭐ Full Screen Reminder (الأفضل هنا)
        .fullScreenCover(isPresented: $navigateToReminderView) {
            ReminderView()
                .environmentObject(router)
                .environmentObject(historyStore)
        }

        .toolbarTitleDisplayMode(.inline)   // ← هنا المكان الصحيح

    }
}


#Preview {
    OptionView()
        .environmentObject(NotificationRouter())
}

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
    
    let customYellow = Color(red: 0.99, green: 0.85, blue: 0.33)
    let customBackground = Color(red: 0.97, green: 0.96, blue: 0.92)
    
    var body: some View {
        VStack(spacing: 50) {
            
            Text("Did you take the insulin shot?")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.top, 50)

            Spacer()

            // ————— YES, START TIMER BUTTON —————
            Button(action: {
                navigateToTimerView = true
            }) {
                VStack {
                    Text(" Yes, Start Timer")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 25)
                .background(customYellow)
                .cornerRadius(14)
            }
            
            // ————— NO, SET REMINDER BUTTON —————
            Button(action: {
                navigateToReminderView = true
            }) {
                VStack {
                    Text("No, Set Reminder")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 25)
                .background(Color.white)
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }
            
            Spacer()
            
        }
        .padding(.horizontal, 50)
        .background(customBackground.ignoresSafeArea())
        
        
        // ————— NAVIGATION DESTINATIONS —————
        
        .navigationDestination(isPresented: $navigateToReminderView) {
            ReminderView()
        }
        
        .navigationDestination(isPresented: $navigateToTimerView) {
            TimerView()
        }
    }
}

#Preview {
    OptionView()
}

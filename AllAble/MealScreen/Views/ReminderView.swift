//
//  ReminderView.swift
//  AllAble
//
//  Created by Rana Alngashy on 12/06/1447 AH.
//

import SwiftUI
import UserNotifications

struct ReminderView: View {
    
    @State private var reminderTime = Date()
    
    @EnvironmentObject var router: NotificationRouter
    @Environment(\.dismiss) private var dismiss
    @State private var goToHome = false   // <<⭐ مهم

    let customYellow = Color(red: 0.99, green: 0.85, blue: 0.33)
    let customBackground = Color(red: 0.97, green: 0.96, blue: 0.92)
    
    @Environment(\.horizontalSizeClass) private var hSize
    private var isCompact: Bool { hSize == .compact }
    
    var body: some View {
        VStack(spacing: isCompact ? 24 : 30) {
            
            Spacer()
            
            Text("Title.SetReminder")
                .font(isCompact ? .title2 : .largeTitle)
                .bold()
                .padding(.top, isCompact ? 20 : 40)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Label.SelectTime")
                    .font(isCompact ? .subheadline : .headline)
                    .padding(.leading)
                
                DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .frame(maxHeight: isCompact ? 140 : 180)
            }
            .padding()
            .background(.white)
            .cornerRadius(12)
            .padding(.horizontal, isCompact ? 20 : 30)
            
            Spacer()
            Spacer()
            
            Button(action: {
                scheduleNotification()
            }) {
                Text("Button.SaveFinish")
                    .font(isCompact ? .title3 : .title3)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, isCompact ? 18 : 24)
                    .background(customYellow)
                    .cornerRadius(14)
            }
            .padding(.horizontal, isCompact ? 20 : 30)
        }
        .background(customBackground.ignoresSafeArea())
        .navigationTitle("Reminder")
        
        // ⭐⭐⭐ HERE — THIS IS THE CORRECT PLACE ⭐⭐⭐
        .fullScreenCover(isPresented: $goToHome) {
            MainPage()
        }
    }
    
    
    // MARK: - Notification Logic
    
    func scheduleNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                self.setLocalNotification()
            } else if let error = error {
                print("Authorization Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    private func setLocalNotification() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("Notification.Title", comment: "")
        content.body = NSLocalizedString("Notification.Body", comment: "")
        content.sound = .default
        content.categoryIdentifier = "OPTIONS_ACTION"
        
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "InsulinReminder", content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    router.navigationPath = NavigationPath()
                    
                    // ⭐⭐ THIS NOW WORKS ⭐⭐
                    goToHome = true
                    
                    print("Notification scheduled. Returning to MainPage.")
                }
            }
        }
    }
}

#Preview {
    ReminderView()
        .environmentObject(NotificationRouter())
}

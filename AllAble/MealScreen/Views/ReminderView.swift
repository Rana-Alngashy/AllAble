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
    
    // 1. Inject the router to access the global path
    @EnvironmentObject var router: NotificationRouter
    
    // Define the custom colors using standard syntax
    let customYellow = Color(red: 0.99, green: 0.85, blue: 0.33)
    let customBackground = Color(red: 0.97, green: 0.96, blue: 0.92)
    
    var body: some View {
        VStack(spacing: 30) {
            
            Text("Set Insulin Reminder")
                .font(.largeTitle)
                .bold()
                .padding(.top)

            Spacer()

            // ————— TIME PICKER —————
            VStack(alignment: .leading) {
                Text("Select Reminder Time")
                    .font(.headline)
                    .padding(.leading)
                    
                DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .frame(maxHeight: 150)
            }
            .padding()
            .background(.white)
            .cornerRadius(12)
            
            Spacer()
            Spacer()
            
            // ————— SAVE BUTTON —————
            Button(action: {
                scheduleNotification()
            }) {
                Text("Save and Finish")
                    .font(.title3.bold())
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(customYellow)
                    .cornerRadius(14)
            }
        }
        .padding(.horizontal, 30)
        .background(customBackground.ignoresSafeArea())
        
    }
    
    // MARK: - Notification Logic
    
    func scheduleNotification() {
        // Request authorization before scheduling
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
        
        content.title = "Insulin Update"
        content.body = "Update your status."
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "OPTIONS_ACTION" // Links to AppDelegate
        
        // Trigger setup (Daily repeat at selected time)
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "InsulinReminder", content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                // 2. CRITICAL FIX: Clear the NavigationPath to pop to the root view (MainPage)
                DispatchQueue.main.async {
                    router.navigationPath = NavigationPath()
                    print("Notification scheduled. Navigation path cleared to return to MainPage.")
                }
            }
        }
    }
}
#Preview {
    ReminderView()
}

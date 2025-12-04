//
//  AllAbleApp.swift
//  AllAble
//
//  Created by Rana Alngashy on 09/06/1447 AH.
//

//import SwiftUI

//@main
//struct AllAbleApp: App {
   // var body: some Scene {
     //   WindowGroup {
         //   MainPage()
       // }
    //}
//}

import SwiftUI
import UserNotifications
import Combine // Required for ObservableObject

// 1. The Global Router State Manager
class NotificationRouter: ObservableObject {
    @Published var shouldNavigateToOptionView = false
    // NEW: The shared path object for the NavigationStack
        @Published var navigationPath = NavigationPath()
}

@main
struct AllAbleApp: App {
    
    @StateObject var router = NotificationRouter()
    
    // Connects the AppDelegate to handle UNUserNotificationCenter events
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        // Pass the router instance to the AppDelegate so it can signal navigation
        appDelegate.router = router
    }

    var body: some Scene {
        WindowGroup {
            MainPage()
                // Make the router available to all subviews
                .environmentObject(router)
        }
    }
}

// 2. Custom AppDelegate to Handle Notification Events
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var router: NotificationRouter?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        
        // Define the custom category identifier used in ReminderView
        let optionsCategory = UNNotificationCategory(
            identifier: "OPTIONS_ACTION",
            actions: [],
            intentIdentifiers: [],
            options: .customDismissAction
        )
        UNUserNotificationCenter.current().setNotificationCategories([optionsCategory])
        
        return true
    }
    
    // Handles the notification click (when the app is backgrounded or closed)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.content.categoryIdentifier == "OPTIONS_ACTION" {
            // Signal the router to navigate on the main thread
            DispatchQueue.main.async {
                self.router?.shouldNavigateToOptionView = true
                print("Notification clicked. Routing to OptionView.")
            }
        }
        
        completionHandler()
    }
    
    // Allows notifications to show even when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .list])
    }
}

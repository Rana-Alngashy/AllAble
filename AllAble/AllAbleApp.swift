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
import Combine

class NotificationRouter: ObservableObject {
    @Published var shouldNavigateToOptionView = false
    @Published var navigationPath = NavigationPath()
}

@main
struct AllAbleApp: App {
   
    @StateObject var router = NotificationRouter()
    
    // 1. Initialize the HistoryStore here
    @StateObject var historyStore = HistoryStore()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        appDelegate.router = router
    }

    var body: some Scene {
        WindowGroup {
            MainPage()
                .environmentObject(router)
                // 2. Inject it here so HistoryView can access it later
                .environmentObject(historyStore)
        }
    }
}

// ... (Keep the rest of your AppDelegate code exactly as it is)
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var router: NotificationRouter?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        let optionsCategory = UNNotificationCategory(identifier: "OPTIONS_ACTION", actions: [], intentIdentifiers: [], options: .customDismissAction)
        UNUserNotificationCenter.current().setNotificationCategories([optionsCategory])
        return true
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.content.categoryIdentifier == "OPTIONS_ACTION" {
            DispatchQueue.main.async {
                self.router?.shouldNavigateToOptionView = true
            }
        }
        completionHandler()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .list])
    }
}



//
//  AllAbleApp.swift
//  AllAble
//
//  Created by Rana Alngashy on 09/06/1447 AH.
//
import SwiftUI
import UserNotifications
import Combine

class NotificationRouter: ObservableObject {
    
    @Published var shouldNavigateToOptionView = false
    @Published var navigationPath = NavigationPath()
}

// 🔑 مفتاح التخزين المشترك
let hasCompletedOnboardingKey = "hasCompletedOnboarding"

@main
struct AllAbleApp: App {
   
    @StateObject var router = NotificationRouter()
    
    // 🔥 1. إضافة مخزن السجل هنا
    @StateObject var historyStore = HistoryStore()
    
    @AppStorage(hasCompletedOnboardingKey) var hasCompletedOnboarding: Bool = false
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        appDelegate.router = router
    }

    var body: some Scene {
        WindowGroup {

            Group {
                // 🎯 التنقل المشروط
                if hasCompletedOnboarding {
                    MainPage()
                        .environmentObject(router)
                        .environmentObject(historyStore)
                } else {
                    SplashView()
                        .environmentObject(router)
                        .environmentObject(historyStore)
                }
            }
            .preferredColorScheme(.light)   // 🌟 ONE LINE THAT FORCES LIGHT MODE
        }
    }
}

// -------------------------------------------------
// MARK: - AppDelegate (Keep same, no changes needed)
// -------------------------------------------------

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var router: NotificationRouter?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        
        let optionsCategory = UNNotificationCategory(
            identifier: "OPTIONS_ACTION",
            actions: [],
            intentIdentifiers: [],
            options: .customDismissAction
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([optionsCategory])
        
        return true
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        
        if response.notification.request.content.categoryIdentifier == "OPTIONS_ACTION" {
            DispatchQueue.main.async {
                self.router?.shouldNavigateToOptionView = true
            }
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        
        completionHandler([.banner, .sound, .list])
    }
}

#Preview {
    let mockRouter = NotificationRouter()
    let mockHistory = HistoryStore()

    return SplashView()
        .environmentObject(mockRouter)
        .environmentObject(mockHistory)
}

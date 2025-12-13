

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

let hasCompletedOnboardingKey = "hasCompletedOnboarding"

@main
struct AllAbleApp: App {

    @StateObject var router = NotificationRouter()
    @StateObject var historyStore = HistoryStore()
    @StateObject var carbRatioStore = CarbRatioStore() // ✅ جديد

    @AppStorage(hasCompletedOnboardingKey) var hasCompletedOnboarding: Bool = false

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        // فقط اربطي الـ router — بدون تغيير لغة النظام
        appDelegate.router = router
    }

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                MainPage()
                    .environmentObject(router)
                    .environmentObject(historyStore)
                    .environmentObject(carbRatioStore) // ✅ جديد
                    .preferredColorScheme(.light)
            } else {
                SplashView()
                    .environmentObject(router)
                    .environmentObject(historyStore)
                    .environmentObject(carbRatioStore) // ✅ جديد
                    .preferredColorScheme(.light)
            }
        }
    }

}

// -------------------------------------------------
// MARK: - AppDelegate
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













//
//import SwiftUI
//import UserNotifications
//import Combine
//
//class NotificationRouter: ObservableObject {
//    @Published var shouldNavigateToOptionView = false
//    @Published var navigationPath = NavigationPath()
//}
//
//let hasCompletedOnboardingKey = "hasCompletedOnboarding"
//
//@main
//struct AllAbleApp: App {
//
//    @StateObject var router = NotificationRouter()
//    @StateObject var historyStore = HistoryStore()
//
//    @AppStorage(hasCompletedOnboardingKey) var hasCompletedOnboarding: Bool = false
//
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//
//    init() {
//        // فقط اربطي الـ router — بدون تغيير لغة النظام
//        appDelegate.router = router
//    }
//
//    var body: some Scene {
//        WindowGroup {
//            if hasCompletedOnboarding {
//                MainPage()
//                    .environmentObject(router)
//                    .environmentObject(historyStore)
//                    .preferredColorScheme(.light)
//            } else {
//                SplashView()
//                    .environmentObject(router)
//                    .environmentObject(historyStore)
//                    .preferredColorScheme(.light)
//            }
//        }
//    }
//
//}
//
//// -------------------------------------------------
//// MARK: - AppDelegate
//// -------------------------------------------------
//
//class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
//
//    var router: NotificationRouter?
//
//    func application(
//        _ application: UIApplication,
//        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
//    ) -> Bool {
//
//        UNUserNotificationCenter.current().delegate = self
//
//        let optionsCategory = UNNotificationCategory(
//            identifier: "OPTIONS_ACTION",
//            actions: [],
//            intentIdentifiers: [],
//            options: .customDismissAction
//        )
//
//        UNUserNotificationCenter.current().setNotificationCategories([optionsCategory])
//
//        return true
//    }
//
//    func userNotificationCenter(
//        _ center: UNUserNotificationCenter,
//        didReceive response: UNNotificationResponse,
//        withCompletionHandler completionHandler: @escaping () -> Void
//    ) {
//        if response.notification.request.content.categoryIdentifier == "OPTIONS_ACTION" {
//            DispatchQueue.main.async {
//                self.router?.shouldNavigateToOptionView = true
//            }
//        }
//        completionHandler()
//    }
//
//    func userNotificationCenter(
//        _ center: UNUserNotificationCenter,
//        willPresent notification: UNNotification,
//        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
//    ) {
//        completionHandler([.banner, .sound, .list])
//    }
//}
//
//#Preview {
//    SplashView()
//        .environmentObject(NotificationRouter())
//        .environmentObject(HistoryStore())
//}

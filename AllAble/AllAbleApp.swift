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

//import SwiftUI
//import UserNotifications
//import Combine // Required for ObservableObject
//
//// 1. The Global Router State Manager
//class NotificationRouter: ObservableObject {
//    @Published var shouldNavigateToOptionView = false
//    // NEW: The shared path object for the NavigationStack
//        @Published var navigationPath = NavigationPath()
//}
//
//@main
//struct AllAbleApp: App {
//    
//    @StateObject var router = NotificationRouter()
//    
//    // Connects the AppDelegate to handle UNUserNotificationCenter events
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//    
//    init() {
//        // Pass the router instance to the AppDelegate so it can signal navigation
//        appDelegate.router = router
//    }
//
//    var body: some Scene {
//        WindowGroup {
//            MainPage()
//                // Make the router available to all subviews
//                .environmentObject(router)
//        }
//    }
//}
//
//// 2. Custom AppDelegate to Handle Notification Events
//class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
//    
//    var router: NotificationRouter?
//    
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        
//        UNUserNotificationCenter.current().delegate = self
//        
//        // Define the custom category identifier used in ReminderView
//        let optionsCategory = UNNotificationCategory(
//            identifier: "OPTIONS_ACTION",
//            actions: [],
//            intentIdentifiers: [],
//            options: .customDismissAction
//        )
//        UNUserNotificationCenter.current().setNotificationCategories([optionsCategory])
//        
//        return true
//    }
//    
//    // Handles the notification click (when the app is backgrounded or closed)
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        
//        if response.notification.request.content.categoryIdentifier == "OPTIONS_ACTION" {
//            // Signal the router to navigate on the main thread
//            DispatchQueue.main.async {
//                self.router?.shouldNavigateToOptionView = true
//                print("Notification clicked. Routing to OptionView.")
//            }
//        }
//        
//        completionHandler()
//    }
//    
//    // Allows notifications to show even when the app is in the foreground
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.banner, .sound, .list])
//    }
//}













//
//import SwiftUI
//import UserNotifications
//import Combine
//
//// 1. The Global Router State Manager (من المشروع الكامل)
//class NotificationRouter: ObservableObject {
//    @Published var shouldNavigateToOptionView = false
//    @Published var navigationPath = NavigationPath()
//}
//
//@main
//struct AllAbleApp: App {
//    
//    @StateObject var router = NotificationRouter()
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//    
////    // FIX: AppStorage لإدارة حالة إكمال شاشات التهيئة (Onboarding)
////    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
//    
//    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
//    
//    
//    init() {
//        appDelegate.router = router
//    }
//
//    var body: some Scene {
//        WindowGroup {
//            // FIX: عرض SplashView في البداية، ثم الانتقال لـ MainPage
//            if hasCompletedOnboarding {
//                MainPage()
//                    .environmentObject(router)
//            } else {
//                // SplashView هي بداية دورة الـ Onboarding
//                SplashView()
//                    .environmentObject(router)
//            }
//        }
//    }
//}
//
//// 2. Custom AppDelegate to Handle Notification Events (من المشروع الكامل)
//class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
//    
//    var router: NotificationRouter?
//    
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        
//        UNUserNotificationCenter.current().delegate = self
//        
//        let optionsCategory = UNNotificationCategory(
//            identifier: "OPTIONS_ACTION",
//            actions: [],
//            intentIdentifiers: [],
//            options: .customDismissAction
//        )
//        UNUserNotificationCenter.current().setNotificationCategories([optionsCategory])
//        
//        return true
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        
//        if response.notification.request.content.categoryIdentifier == "OPTIONS_ACTION" {
//            DispatchQueue.main.async {
//                self.router?.shouldNavigateToOptionView = true
//                print("Notification clicked. Routing to OptionView.")
//            }
//        }
//        
//        completionHandler()
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.banner, .sound, .list])
//    }
//}
//#Preview {
//    // إنشاء كائن وهمي (Mock) للـ Router لأنه مطلوب في بيئة التطبيق
//    let mockRouter = NotificationRouter()
//    
//    // معاينة الواجهة الجذرية الافتراضية (SplashView) مع حقن الـ Router
//    SplashView()
//        .environmentObject(mockRouter)
//}












//
////
////  AllAbleApp.swift
////  AllAble
////
////  Created by Rana Alngashy on 09/06/1447 AH.
////
//
//import SwiftUI
//import UserNotifications
//import Combine
//
//// 1. The Global Router State Manager
//class NotificationRouter: ObservableObject {
//    @Published var shouldNavigateToOptionView = false
//    @Published var navigationPath = NavigationPath()
//}
//
//// 2. Custom AppDelegate (يتم الاحتفاظ به كما هو)
//class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
//    
//    var router: NotificationRouter?
//    
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        
//        UNUserNotificationCenter.current().delegate = self
//        
//        let optionsCategory = UNNotificationCategory(
//            identifier: "OPTIONS_ACTION",
//            actions: [],
//            intentIdentifiers: [],
//            options: .customDismissAction
//        )
//        UNUserNotificationCenter.current().setNotificationCategories([optionsCategory])
//        
//        return true
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        
//        if response.notification.request.content.categoryIdentifier == "OPTIONS_ACTION" {
//            DispatchQueue.main.async {
//                self.router?.shouldNavigateToOptionView = true
//                print("Notification clicked. Routing to OptionView.")
//            }
//        }
//        
//        completionHandler()
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.banner, .sound, .list])
//    }
//}
//
//// 🔑 مفتاح التخزين المشترك
//let hasCompletedOnboardingKey = "hasCompletedOnboarding"
//
//
//@main
//struct AllAbleApp: App {
//    
//    @StateObject var router = NotificationRouter()
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//    
//    // 🔥 قراءة العلامة العامة للتحويل
//    @AppStorage(hasCompletedOnboardingKey) var hasCompletedOnboarding: Bool = false
//    
//    init() {
//        appDelegate.router = router
//    }
//
//    var body: some Scene {
//        WindowGroup {
//            // 🎯 التنقل المشروط: إذا تم التحقق، اذهب لـ MainPage
//            if hasCompletedOnboarding {
//                MainPage() // تم إكمال التسجيل
//                    .environmentObject(router)
//            } else {
//                SplashView() // ابدأ عملية الإعداد
//                    .environmentObject(router)
//            }
//        }
//    }
//}







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
            // 🎯 التنقل المشروط
            if hasCompletedOnboarding {
                MainPage()
                    .environmentObject(router)
                    // 2. حقن مخزن السجل في البيئة
                    .environmentObject(historyStore)
            } else {
                SplashView()
                    .environmentObject(router)
                    // 2. حقن مخزن السجل في البيئة
                    .environmentObject(historyStore)
            }
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
#Preview {
    // إنشاء كائن وهمي (Mock) للـ Router لأنه مطلوب في بيئة التطبيق
    let mockRouter = NotificationRouter()

    // معاينة الواجهة الجذرية الافتراضية (SplashView) مع حقن الـ Router
    SplashView()
        .environmentObject(mockRouter)
}

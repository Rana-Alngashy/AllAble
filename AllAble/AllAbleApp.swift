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
//
//
//  AllAbleApp.swift
//  AllAble
//
//  Created by Rana Alngashy on 09/06/1447 AH.
//

import SwiftUI
import UserNotifications

@main
struct AllAbleApp: App {
    // ViewModels for the Root Switcher
    @StateObject var appFlow = AppFlowViewModel()
    @StateObject var onboardingVM = OnboardingViewModel()
    
    // The Global Router (Used ONLY for Child Mode/MainPage now)
    @StateObject var router = NotificationRouter()
    
    // 🆕 NEW: A separate path just for Onboarding so it doesn't break MainPage
    @State private var onboardingPath = NavigationPath()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        appDelegate.router = router
    }

    var body: some Scene {
        WindowGroup {
            Group {
                switch appFlow.currentState {
                case .splash:
                    SplashView()
                        .onAppear {
                            appFlow.checkUserStatus()
                        }
                    
                case .onboarding, .childSetup:
                    // ✅ FIXED: Use 'onboardingPath' instead of 'router.navigationPath'
                    NavigationStack(path: $onboardingPath) {
                        ParentLoginView(viewModel: onboardingVM, path: $onboardingPath)
                            .navigationDestination(for: String.self) { destination in
                                switch destination {
                                case "Acknowledgement":
                                    AcknowledgmentView(path: $onboardingPath)
                                    
                                case "ChildInfo":
                                    ChildInfoView(viewModel: onboardingVM, path: $onboardingPath)
                                    
                                case "CarbRatio":
                                    CarbRatioVerificationView(viewModel: onboardingVM, path: $onboardingPath)
                                    
                                case "AvatarSelection":
                                    AvatarSelectionView(viewModel: onboardingVM)
                                    
                                default:
                                    EmptyView()
                                }
                            }
                    }
                    
                case .childMode:
                    // This uses the clean 'router' path, so it starts fresh!
                    ChildModeWrapper()
                }
            }
            .environmentObject(appFlow)
            .environmentObject(onboardingVM)
            .environmentObject(router)
            .environment(\.layoutDirection, .leftToRight)
            .animation(.default, value: appFlow.currentState)
        }
    }
}

// MARK: - App Delegate
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var router: NotificationRouter?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
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

//
//  SplashViewModel.swift
//  AllAble
//
//  Created by Wteen Alghamdy on 15/06/1447 AH.
//






//
//import Foundation
//import Combine
///// Manages the state and business logic for the SplashView.
//final class SplashViewModel: ObservableObject {
//    @Published var shouldNavigateToNextScreen = false
//    
//    func startAppInitialization() {
//        // Simulate a short loading/initialization process
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            // Trigger navigation after the simulated delay
//            self.shouldNavigateToNextScreen = true
//        }
//    }
//}
//





import SwiftUI
import Combine

class SplashViewModel: ObservableObject {
    @Published var shouldNavigateToNextScreen = false
    
    func startAppInitialization() {
        // محاكاة وقت التحميل
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.shouldNavigateToNextScreen = true
        }
    }
}

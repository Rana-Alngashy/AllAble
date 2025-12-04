//
//  AppFlowViewModel.swift
//  AllAble
//
//  Created by Rana Alngashy on 13/06/1447 AH.
//

//
//  AppFlowViewModel.swift
//  AllAble
//
//  Created by AllAble Architect.
//
//
//  AppFlowViewModel.swift
//  AllAble
//
//  Created by AllAble Architect.
//

import SwiftUI
import Combine

enum AppState {
    case splash
    case onboarding
    case childSetup
    case childMode
}

class AppFlowViewModel: ObservableObject {
    @Published var currentState: AppState = .splash
    @Published var childProfile: ChildProfile = ChildProfile()
    
    // Check if user is already setup
    func checkUserStatus() {
        Task {
            // Simulate loading delay
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            DispatchQueue.main.async {
                let isSetupComplete = UserDefaults.standard.bool(forKey: "isSetupComplete")
                
                if isSetupComplete {
                    self.loadProfile()
                    withAnimation { self.currentState = .childMode }
                } else {
                    withAnimation { self.currentState = .onboarding }
                }
            }
        }
    }
    
    func completeOnboarding() {
        saveProfile()
        UserDefaults.standard.set(true, forKey: "isSetupComplete")
        withAnimation {
            self.currentState = .childMode
        }
    }
    
    // ✅ NEW: Public function to update profile from AccountPage
    func updateProfile(name: String, age: String, guardianNumber: String, carbRatio: Double, avatarName: String) {
        self.childProfile.name = name
        self.childProfile.age = age
        self.childProfile.guardianNumber = guardianNumber
        self.childProfile.carbRatio = carbRatio
        self.childProfile.avatarName = avatarName
        
        saveProfile() // Save immediately to UserDefaults
    }
    
    // MARK: - Persistence Logic
    private func saveProfile() {
        UserDefaults.standard.set(childProfile.name, forKey: "account.name")
        UserDefaults.standard.set(childProfile.age, forKey: "account.age")
        UserDefaults.standard.set(childProfile.guardianNumber, forKey: "account.guardianNumber")
        UserDefaults.standard.set(String(childProfile.carbRatio), forKey: "account.carbonValue")
        UserDefaults.standard.set(childProfile.avatarName, forKey: "account.avatar")
    }
    
    private func loadProfile() {
        let name = UserDefaults.standard.string(forKey: "account.name") ?? ""
        let age = UserDefaults.standard.string(forKey: "account.age") ?? ""
        let guardian = UserDefaults.standard.string(forKey: "account.guardianNumber") ?? ""
        let carbString = UserDefaults.standard.string(forKey: "account.carbonValue") ?? "15"
        let avatar = UserDefaults.standard.string(forKey: "account.avatar") ?? "AvatarGirl"
        
        self.childProfile = ChildProfile(
            name: name,
            age: age,
            guardianNumber: guardian,
            carbRatio: Double(carbString) ?? 15.0,
            avatarName: avatar
        )
    }
}

struct ChildProfile {
    var name: String = ""
    var age: String = ""
    var guardianNumber: String = "" // Added field
    var carbRatio: Double = 15.0
    var avatarName: String = "AvatarGirl"
}

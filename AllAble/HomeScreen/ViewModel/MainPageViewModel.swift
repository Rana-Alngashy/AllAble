//
//  MainPageViewModel.swift
//  AllAble
//
//  Created by lamess on 10/06/1447 AH.
//

import Foundation
import Combine

class MainPageViewModel: ObservableObject {
    
    @Published var userName: String = "ساره"    // يتغير حسب اللي يدخله اليوزر
    @Published var lastDose: Int = 6            // جرعة افتراضية
    
    func calculateMeal() {
        print("Go to calculate meal screen")
    }
    
    func showPreviousMeals() {
        print("Go to previous meals screen")
    }
    
    func openProfile() {
        print("Open Profile page")
    }
    
    func openNotifications() {
        print("Open Notifications page")
    }
}

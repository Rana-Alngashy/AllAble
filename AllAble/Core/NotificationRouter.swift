//
//  NotificationRouter.swift
//  AllAble
//
//  Created by Rana Alngashy on 13/06/1447 AH.
//

//
//  NotificationRouter.swift
//  AllAble
//
//  Created by AllAble Architect.
//

import SwiftUI
import Combine

class NotificationRouter: ObservableObject {
    // Navigate to the OptionView (Yes/No screen) when notification is clicked
    @Published var shouldNavigateToOptionView = false
    
    // Global navigation path for the root stack
    @Published var navigationPath = NavigationPath()
}

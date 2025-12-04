//
//  ChildModeWrapper.swift
//  AllAble
//
//  Created by Rana Alngashy on 13/06/1447 AH.
//

import SwiftUI

struct ChildModeWrapper: View {
    // We access the AppFlow to greet the user by name if needed
    @EnvironmentObject var appFlow: AppFlowViewModel
    @EnvironmentObject var router: NotificationRouter
    
    var body: some View {
       
        MainPage()
            .environmentObject(router) // Pass the router down to your existing code
            .onAppear {
                print("DEBUG: Switching to Child Mode for \(appFlow.childProfile.name)")
            }
    }
}

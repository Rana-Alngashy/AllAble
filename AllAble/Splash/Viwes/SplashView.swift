//
//  SplashView.swift
//  AllAble
//
//  Created by Wteen Alghamdy on 14/06/1447 AH.
//

import SwiftUI

struct SplashView: View {
    @StateObject var viewModel = SplashViewModel()
    @EnvironmentObject var router: NotificationRouter
    @EnvironmentObject var historyStore: HistoryStore

    @State private var animate = false
    
    let backgroundColor = Color(#colorLiteral(red: 0.992, green: 0.863, blue: 0.345, alpha: 1))
    let starSplashImage = "logoSplash"
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            VStack {
                Spacer()

                Image(starSplashImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.60)
                    .scaleEffect(animate ? 1 : 0.6)
                    .opacity(animate ? 1 : 0)
                    .offset(y: animate ? 0 : 40)
                    .animation(.easeOut(duration: 1.2), value: animate)
                
                Spacer()
            }
            .onAppear {
                animate = true
                viewModel.startAppInitialization()
            }
        }
        .fullScreenCover(isPresented: $viewModel.shouldNavigateToNextScreen) {
            AvatarSelectionView()
                .environmentObject(router)        // ← مهم جدًا
                .environmentObject(historyStore)  // ← مهم جدًا
        }
    }
}


//
//  SplashView.swift
//  AllAble
//
//  Created by Wteen Alghamdy on 14/06/1447 AH.
//








//import SwiftUI
//
//struct SplashView: View {
//    @StateObject var viewModel = SplashViewModel()
//    
//    // FIX: تعريف الألوان محلياً بدلاً من AppConstants
//    let backgroundColor = Color(red: 0.97, green: 0.96, blue: 0.92)
//    let starSplashImage = "starSplashImg"
//    
//    var body: some View {
//        ZStack {
//            backgroundColor.edgesIgnoringSafeArea(.all)
//            
//            VStack {
//                Spacer()
//                
//                // FIX: استخدام اسم الـ Asset مباشرة
//                Image(starSplashImage)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 1100, height: 1100)
//                    .padding(.top, 200)
//
//            }
//            .contentShape(Rectangle())
//            .onAppear {
//                viewModel.startAppInitialization()
//            }
//            .environment(\.layoutDirection, .rightToLeft) // FIX: تطبيق اتجاه العرض
//        }
//        .fullScreenCover(isPresented: $viewModel.shouldNavigateToNextScreen) {
//            AvatarSelectionView()
//        }
//    }
//}
//








import SwiftUI

struct SplashView: View {
    @StateObject var viewModel = SplashViewModel()
    
    // FIX: تعريف الألوان محلياً بدلاً من AppConstants
    let backgroundColor = Color(red: 0.97, green: 0.96, blue: 0.92)
    let starSplashImage = "starSplashImg"
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Image(starSplashImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 1100, height: 1100)
                    .padding(.top, 200)

            }
            .contentShape(Rectangle())
            .onAppear {
                viewModel.startAppInitialization()
            }
            .environment(\.layoutDirection, .rightToLeft) // FIX: تطبيق اتجاه العرض
        }
        .fullScreenCover(isPresented: $viewModel.shouldNavigateToNextScreen) {
            AvatarSelectionView()
        }
    }
}
#Preview {
    SplashView()
}


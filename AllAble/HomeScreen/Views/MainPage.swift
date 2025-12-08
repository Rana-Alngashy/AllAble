//
//  MainPage.swift
//  AllAble
//
//  Created by lamess on 10/06/1447 AH.
//
//



//
//import SwiftUI
//
//struct MainPage: View {
//    // 1. REQUIRED INJECTION: Read the router object from the environment
//    @EnvironmentObject var router: NotificationRouter
//    @StateObject private var viewModel = MainPageViewModel()
//    // FIX: قراءة اسم صورة الأفاتار المخزن من دورة الـ Onboarding
//        @AppStorage("selectedAvatarImageName") private var selectedAvatarImageName: String = "AvatarGirl" // الافتراضي
//        // FIX: قراءة اسم المستخدم المخزن من دورة الـ Onboarding
//        @AppStorage("account.name") private var userName: String = "Sarah" // الافتراضي
//    
//    var body: some View {
//        NavigationStack(path: $router.navigationPath) {
//            ZStack {
//                Color(#colorLiteral(red: 0.98, green: 0.96, blue: 0.90, alpha: 1))
//                    .ignoresSafeArea()
//                VStack {
//                    
//                    //tool bar
//                    HStack {
//                        Spacer()
//                        
//                        Button(action: {
//                            // go to notifications
//                        }) {
//                            Image(systemName: "bell.fill")
//                                .font(.system(size: 50))
//                                .foregroundColor(.yellow)
//                        }
//                        
//                        NavigationLink(destination: AccountPage()) {
//                            Image(systemName: "person.circle.fill")
//                                .font(.system(size: 50))
//                                .foregroundColor(.yellow)
//                        }
//                    }
//                    .padding(.horizontal, 30)
//                    .padding(.top, 20)
//                    
//                    Spacer()
//                    
//                    HStack(alignment: .center, spacing: 60) {
//                        
//                        // LEFT SIDE (carbs + buttons)
//                        VStack(spacing: 35) {
//                            
//                            //  MAIN WHITE BOX
//                            VStack(spacing: 14) {
//                                Text("Last insulin dose calculation")
//                                    .font(.system(size: 22, weight: .medium))
//                                    .foregroundColor(.gray)
//                                
//                                Text("6 for Lunch")
//                                    .font(.system(size: 64, weight: .heavy))
//                                    .foregroundColor(Color(#colorLiteral(red: 0.12, green: 0.18, blue: 0.45, alpha: 1)))
//                            }
//                            .frame(width: 520, height: 270)
//                            .background(.white)
//                            .cornerRadius(28)
//                            .shadow(color: .black.opacity(0.07), radius: 8, y: 4)
//                            
//                            // CALCULATE MY MEAL BUTTON
//                            NavigationLink(destination: AddMealView()) {
//                                Text("Calculate My Meal")
//                                    .font(.system(size: 32, weight: .semibold))
//                                    .foregroundColor(.black)
//                                    .frame(width: 520, height: 85)
//                                    .background(Color(#colorLiteral(red: 0.99, green: 0.85, blue: 0.33, alpha: 1)))
//                                    .cornerRadius(16)
//                            }
//                            
//                            
//                            // PREVIOUS MEALS BUTTON
//                            Button(action: {}) {
//                                Text("My Previous Meals")
//                                    .font(.system(size: 30, weight: .medium))
//                                    .foregroundColor(.black)
//                                    .frame(width: 520, height: 85)
//                                    .overlay(
//                                        RoundedRectangle(cornerRadius: 16)
//                                            .stroke(Color(#colorLiteral(red: 0.99, green: 0.85, blue: 0.33, alpha: 1)), lineWidth: 3)
//                                    )
//                            }
//                        }
//                        
//                        // AVATAR + NAME
//                        VStack(spacing: 18) {
//                            Image(selectedAvatarImageName)
//                                            .resizable()
//                                            .scaledToFit()
//                                            .frame(width: 400, height: 500)
//                                            .background(.white)
//                                            .cornerRadius(36)
//                                            .shadow(color: .black.opacity(0.07), radius: 8, y: 4)
//                            
//                            Text(userName)
//                                            .font(.system(size: 30, weight: .medium))
//                                            .foregroundColor(.black)
//                        }
//                    }
//                    
//                    Spacer()
//                }
//                .padding(.horizontal, 50)
//            }
//            .navigationDestination(isPresented: $router.shouldNavigateToOptionView) {
//                OptionView()
//            }
//            .task {
//                if router.shouldNavigateToOptionView {
//                    router.shouldNavigateToOptionView = true
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    MainPage()
//        .environmentObject(NotificationRouter())
//}







//
////
////  MainPage.swift
////  AllAble
////
////  Created by lamess on 10/06/1447 AH.
////
//
//import SwiftUI
//
//struct MainPage: View {
//    
//    @EnvironmentObject var router: NotificationRouter
//    @AppStorage("selectedAvatarImageName") private var selectedAvatarImageName: String = "AvatarGirl"
//    @AppStorage("account.name") private var userName: String = "Sarah"
//    @Environment(\.horizontalSizeClass) private var hSize
//
//    @StateObject private var viewModel = MainPageViewModel()
//    
//    private var isCompact: Bool {
//          hSize == .compact   // iPhone أغلب الوقت
//      }
//    
//    var body: some View {
//        NavigationStack(path: $router.navigationPath) {
//            ZStack {
//                Color(#colorLiteral(red: 0.98, green: 0.96, blue: 0.90, alpha: 1))
//                    .ignoresSafeArea()
//                VStack {
//                    
//                    //tool bar
//                    HStack {
//                        Spacer()
//                        
//                     
//                        NavigationLink(destination: AccountPage()) {
//                            Image(systemName: "person.circle.fill")
//                                .font(.system(size: isCompact ? 28 : 50))
//                                .foregroundColor(.yellow)
//                        }
//                    }
//                    .padding(.horizontal, 30)
//                    .padding(.top, 20)
//                    
//                    Spacer()
//                    
//                    HStack(alignment: .center, spacing: 60) {
//                        
//                        // LEFT SIDE (carbs + buttons)
//                        VStack(spacing: 35) {
//                            
//                            //  MAIN WHITE BOX
//                            VStack(spacing: 14) {
//                                Text("Last insulin dose calculation")
//                                    .font(.system(size: 22, weight: .medium))
//                                    .foregroundColor(.gray)
//                                
//                                // عرض اسم المستخدم وقيمة افتراضية للجرعة
//                                Text("\(viewModel.lastDose) for \(viewModel.userName)")
//                                    .font(.system(size: 64, weight: .heavy))
//                                    .foregroundColor(Color(#colorLiteral(red: 0.12, green: 0.18, blue: 0.45, alpha: 1)))
//                            }
//                            .frame(width: 520, height: 270)
//                            .background(.white)
//                            .cornerRadius(28)
//                            .shadow(color: .black.opacity(0.07), radius: 8, y: 4)
//                            
//                            // CALCULATE MY MEAL BUTTON
//                            NavigationLink(destination: AddMealView()) {
//                                Text("Calculate My Meal")
//                                    .font(.system(size: 32, weight: .semibold))
//                                    .foregroundColor(.black)
//                                    .frame(width: 520, height: 85)
//                                    .background(Color(#colorLiteral(red: 0.99, green: 0.85, blue: 0.33, alpha: 1)))
//                                    .cornerRadius(16)
//                            }
//                            
//                            
//                            // 🔥 MY PREVIOUS MEALS BUTTON
//                            NavigationLink(destination: HistoryView()) {
//                                Text("My Previous Meals")
//                                    .font(.system(size: 30, weight: .medium))
//                                    .foregroundColor(.black)
//                                    .frame(width: 520, height: 85)
//                                    .overlay(
//                                        RoundedRectangle(cornerRadius: 16)
//                                            .stroke(Color(#colorLiteral(red: 0.99, green: 0.85, blue: 0.33, alpha: 1)), lineWidth: 3)
//                                    )
//                            }
//                            
//                        }
//                        
//                        // AVATAR + NAME
//                        VStack(spacing: 18) {
//                            // 🔥 استخدام الأفاتار واسم المستخدم المحفوظ
//                            Image(selectedAvatarImageName)
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 400, height: 500)
//                                .background(.white)
//                                .cornerRadius(36)
//                                .shadow(color: .black.opacity(0.07), radius: 8, y: 4)
//                            
//                            Text(userName)
//                                .font(.system(size: 30, weight: .medium))
//                                .foregroundColor(.black)
//                        }
//                    }
//                    
//                    Spacer()
//                }
//                .padding(.horizontal, 50)
//            }
//            .navigationDestination(isPresented: $router.shouldNavigateToOptionView) {
//                OptionView()
//            }
//            .task {
//                if router.shouldNavigateToOptionView {
//                    router.shouldNavigateToOptionView = true
//                }
//            }
//        }
//    }
//}

import SwiftUI

struct MainPage: View {
    
    @EnvironmentObject var router: NotificationRouter
    @AppStorage("selectedAvatarImageName") private var selectedAvatarImageName: String = "AvatarGirl"
    @AppStorage("account.name") private var userName: String = "Sarah"
    
    @Environment(\.horizontalSizeClass) private var hSize
    @StateObject private var viewModel = MainPageViewModel()
    
    private var isCompact: Bool {
        hSize == .compact   // iPhone
    }
    
    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            ZStack {
                Color(#colorLiteral(red: 0.98, green: 0.96, blue: 0.90, alpha: 1))
                    .ignoresSafeArea()
                
                VStack {
                    
                    // MARK: - Toolbar
                    HStack {
                        Spacer()
                        NavigationLink(destination: AccountPage()) {
                            Image(systemName: "person.circle.fill")
                                .font(isCompact ? .title2 : .largeTitle) // ✅ Dynamic Type
                                .foregroundColor(.yellow)
                        }
                    }
                    .padding(.horizontal, isCompact ? 20 : 30)
                    .padding(.top, isCompact ? 10 : 20)
                    
                    Spacer(minLength: isCompact ? 20 : 40)
                    
                    // MARK: - Main Layout (iPhone / iPad)
                    if isCompact {
                        // 📱 iPhone (عمودي)
                        VStack(spacing: 24) {
                            mainInfoCard
                            calculateButton
                            historyButton
                            avatarSection
                        }
                        .padding(.horizontal, 20)
                    } else {
                        // 💻 iPad (أفقي)
                        HStack(alignment: .center, spacing: 60) {
                            VStack(spacing: 35) {
                                mainInfoCard
                                calculateButton
                                historyButton
                            }
                            avatarSection
                        }
                        .padding(.horizontal, 50)
                    }
                    
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $router.shouldNavigateToOptionView) {
                OptionView()
            }
        }
    }
    
    // MARK: - Components
    
    private var mainInfoCard: some View {
        VStack(spacing: 14) {
            Text("Last insulin dose calculation")
                .font(.headline)                      // ✅ Dynamic Type
                .foregroundColor(.gray)
            
            Text("\(viewModel.lastDose) for \(viewModel.userName)")
                .font(isCompact ? .largeTitle : .system(.largeTitle, weight: .heavy)) // ✅
                .foregroundColor(Color(#colorLiteral(red: 0.12, green: 0.18, blue: 0.45, alpha: 1)))
                .minimumScaleFactor(0.6)
                .lineLimit(1)
        }
        .padding(.vertical, isCompact ? 16 : 24)
        .padding(.horizontal, 20)
        .frame(maxWidth: isCompact ? .infinity : 520)
        .background(Color.white)
        .cornerRadius(28)
        .shadow(color: .black.opacity(0.07), radius: 8, y: 4)
    }
    
    private var calculateButton: some View {
        NavigationLink(destination: AddMealView()) {
            Text("Calculate My Meal")
                .font(isCompact ? .headline : .title2)   // ✅ Dynamic Type
                .foregroundColor(.black)
                .frame(maxWidth: isCompact ? .infinity : 520)
                .frame(height: isCompact ? 60 : 85)
                .background(Color(#colorLiteral(red: 0.99, green: 0.85, blue: 0.33, alpha: 1)))
                .cornerRadius(16)
        }
    }
    
    private var historyButton: some View {
        NavigationLink(destination: HistoryView()) {
            Text("My Previous Meals")
                .font(isCompact ? .body : .title3)   // ✅ Dynamic Type
                .foregroundColor(.black)
                .frame(maxWidth: isCompact ? .infinity : 520)
                .frame(height: isCompact ? 56 : 85)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(#colorLiteral(red: 0.99, green: 0.85, blue: 0.33, alpha: 1)), lineWidth: 3)
                )
        }
    }
    
    private var avatarSection: some View {
        VStack(spacing: 18) {
            Image(selectedAvatarImageName)
                .resizable()
                .scaledToFit()
                .frame(
                    width: isCompact ? 220 : 400,
                    height: isCompact ? 280 : 500
                )
                .background(.white)
                .cornerRadius(36)
                .shadow(color: .black.opacity(0.07), radius: 8, y: 4)
            
            Text(userName)
                .font(isCompact ? .headline : .title2)  // ✅ Dynamic Type
                .foregroundColor(.black)
        }
    }
}

#Preview {
    MainPage()
        .environmentObject(NotificationRouter())
}

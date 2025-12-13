//
//  CalculateView.swift
//  AllAble
//
//  Created by Rana Alngashy on 12/06/1447 AH.
//
//

import SwiftUI

struct CalculateView: View {
    @EnvironmentObject var router: NotificationRouter
    
    // We still need the store in the environment, but we won't use it here anymore
    @EnvironmentObject var historyStore: HistoryStore
    
    
    // MARK: - Properties
    let totalCarbs: Int
    let mealName: String
    let mealType: String
    
    // NEW: pass details for history
    let mainMealCarbs: Double
    let subItems: [MealSubItem]
    
    // ✅ إضافة النسبة المختارة
    let carbRatioEntry: CarbRatioEntry
    
    @State private var navigateToOptionView = false
    
    let circleMaxSize: CGFloat = 300
    let customBackground = Color(red: 0.97, green: 0.96, blue: 0.92)
    
    var carbRatio: Double {
        // ✅ استخدام النسبة المرسلة
        return carbRatioEntry.ratio
    }
    
    var insulinDose: Double {
                guard totalCarbs > 0 && carbRatio > 0 else { return 0.0 }
                let calculatedValue = Double(totalCarbs) / carbRatio
                return round(calculatedValue)
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack(spacing: 30) {
                    
                    Text("Title.InsulinDose")
                        .font(.system(size: geometry.size.width * (0.05 / 1.5), weight: .bold)) // Adjust font size relative to width
                        .foregroundColor(.gray)
                        .padding(.top, 40)
                    
                    // ————— DOSE DISPLAY —————
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: circleMaxSize, height: circleMaxSize)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                        
                        VStack {
                            Text(formatDose(insulinDose))
                                .font(.system(size: circleMaxSize * 0.4, weight: .heavy))
                                .foregroundColor(Color(red: 0.99, green: 0.85, blue: 0.33))
                            
                            Text("Units")
                                .font(.system(size: circleMaxSize * 0.1, weight: .medium))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // ————— INFORMATION CARDS —————
                    VStack(spacing: 15) {
                        
                        // Total Carbs Card
                        InfoCard(
                            title: NSLocalizedString("TotalCarbs", comment: "").replacingOccurrences(of: ":", with: ""), // إزالة النقطتين
                            value: "\(totalCarbs) g",
                            icon: "fork.knife"
                        )
                        
                        // Carb Ratio Card
                        InfoCard(
                            title: NSLocalizedString("Label.CarbRatio", comment: ""),
                            value: "\(String(format: "%.1f", carbRatio)) g/unit (\(carbRatioEntry.name))", // ✅ عرض اسم النسبة
                            icon: "divide.circle.fill"
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // ————— CONTINUE BUTTON —————
                    Button(action: {
                        navigateToOptionView = true
                    }) {
                        Text("Button.Continue")
                            .font(.title3.bold())
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color(red: 0.99, green: 0.85, blue: 0.33))
                            .cornerRadius(14)
                    }
                    .padding(.horizontal, 50)
                    .padding(.bottom, 50)

                }
                .frame(maxWidth: 600)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(customBackground.ignoresSafeArea())
            
            // ————— PASS DATA TO OPTION VIEW —————
            .navigationDestination(isPresented: $navigateToOptionView) {
                OptionView(
                    mealType: mealType,
                    mealName: mealName.isEmpty ? mealType : mealName,
                    carbs: Double(totalCarbs),
                    dose: insulinDose,
                    mainMealCarbs: mainMealCarbs,
                    subItems: subItems
                )
            }
        }
    }
    
    // دالة لتنسيق الجرعة إلى أقرب 0.5 (إذا كانت الجرعة الصحيحة فقط، عرضها كعدد صحيح)
    private func formatDose(_ dose: Double) -> String {
        if dose.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", dose)
        } else {
            return String(format: "%.1f", dose)
        }
    }
}

// Helper View
struct InfoCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(Color(red: 0.99, green: 0.85, blue: 0.33))
            
            VStack(alignment: .leading) {
                Text(title).font(.caption).foregroundColor(.gray)
                Text(value).font(.title3).bold().foregroundColor(.black)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}
// MARK: - Preview (أبسط صورة)

#Preview {
    let mockRatio = CarbRatioEntry(name: "Lunch", ratio: 10.0)
    let mockSubItems: [MealSubItem] = [] // بيانات وهمية فارغة
    
    return NavigationStack {
        CalculateView(
            totalCarbs: 85,
            mealName: "Pizza Night",
            mealType: "Dinner",
            mainMealCarbs: 85,
            subItems: mockSubItems,
            carbRatioEntry: mockRatio
        )
        // توفير الـ Environment Objects المطلوبة
        .environmentObject(NotificationRouter())
        .environmentObject(HistoryStore())
        .environment(\.locale, Locale(identifier: "ar"))
    }
}








//
//import SwiftUI
//
//struct CalculateView: View {
//    @EnvironmentObject var router: NotificationRouter
//    
//    // We still need the store in the environment, but we won't use it here anymore
//    @EnvironmentObject var historyStore: HistoryStore
//    
//    @AppStorage("Account.CarbValue") private var storedCarbRatio: String = ""
//    
//    // MARK: - Properties
//    let totalCarbs: Int
//    let mealName: String
//    let mealType: String
//    
//    // NEW: pass details for history
//    let mainMealCarbs: Double
//    let subItems: [MealSubItem]
//    
//    @State private var navigateToOptionView = false
//    
//    let circleMaxSize: CGFloat = 300
//    let customBackground = Color(red: 0.97, green: 0.96, blue: 0.92)
//    
//    var carbRatio: Double {
//        return Double(storedCarbRatio) ?? 15.0
//    }
//    
//    var insulinDose: Double {
//        guard totalCarbs > 0 && carbRatio > 0 else { return 0.0 }
//        let calculatedValue = Double(totalCarbs) / carbRatio
//        return round(calculatedValue)
//    }
//
//    var body: some View {
//        GeometryReader { geometry in
//            VStack {
//                VStack(spacing: 30) {
//                    
//                    Text("Title.InsulinDose")
//                        .font(.system(size: 34, weight: .bold))
//                        .padding(.top, 40)
//                    
//                    // ————— DETAILS BAR —————
//                    HStack(spacing: 20) {
//                        InfoCard(title: NSLocalizedString("TotalCarbs", comment: ""), value: "\(totalCarbs)g", icon: "fork.knife")
//                        InfoCard(title: NSLocalizedString("Label.CarbRatio", comment: ""), value: "1 : \(Int(carbRatio))", icon: "drop.fill")
//                        
//                    }
//                    .padding(.horizontal, 40)
//                    
//                    Spacer()
//                    
//                    // ————— CIRCLE DISPLAY —————
//                    ZStack {
//                        Circle()
//                            .fill(
//                                LinearGradient(
//                                    gradient: Gradient(colors: [
//                                        Color(red: 1.0, green: 0.85, blue: 0.9),
//                                        Color(red: 0.95, green: 0.65, blue: 0.75)
//                                    ]),
//                                    startPoint: .top,
//                                    endPoint: .bottom
//                                )
//                            )
//                            .frame(width: min(geometry.size.width * 0.5, circleMaxSize),
//                                   height: min(geometry.size.width * 0.5, circleMaxSize))
//                            .shadow(radius: 5)
//
//                        Text(String(format: "%.0f", insulinDose))
//                            .font(.system(size: 100, weight: .heavy))
//                            .foregroundColor(.white)
//                    }
//                    
//                    Spacer()
//                    
//                    // ————— CONTINUE BUTTON —————
//                    Button(action: {
//                        navigateToOptionView = true
//                    }) {
//                        Text("Button.Continue")
//                            .font(.title3.bold())
//                            .foregroundColor(.black)
//                            .frame(maxWidth: .infinity)
//                            .padding(.vertical, 15)
//                            .background(Color.white)
//                            .cornerRadius(14)
//                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 14)
//                                    .stroke(Color.gray, lineWidth: 1)
//                            )
//                    }
//                    .padding(.horizontal, 50)
//                    .padding(.bottom, 50)
//
//                }
//                .frame(maxWidth: 600)
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(customBackground.ignoresSafeArea())
//            
//            // ————— PASS DATA TO OPTION VIEW —————
//            .navigationDestination(isPresented: $navigateToOptionView) {
//                OptionView(
//                    mealType: mealType,
//                    mealName: mealName.isEmpty ? mealType : mealName,
//                    carbs: Double(totalCarbs),
//                    dose: insulinDose,
//                    mainMealCarbs: mainMealCarbs,
//                    subItems: subItems
//                )
//            }
//        }
//    }
//}
//
//// Helper View
//struct InfoCard: View {
//    let title: String
//    let value: String
//    let icon: String
//    
//    var body: some View {
//        HStack {
//            Image(systemName: icon)
//                .font(.title2)
//                .foregroundColor(Color(red: 0.99, green: 0.85, blue: 0.33))
//            
//            VStack(alignment: .leading) {
//                Text(title).font(.caption).foregroundColor(.gray)
//                Text(value).font(.title3).bold().foregroundColor(.black)
//            }
//            Spacer()
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(12)
//        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
//    }
//}
//

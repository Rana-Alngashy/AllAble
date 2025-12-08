//
//  HistoryView.swift
//  AllAble
//
//  Created by Wteen Alghamdy on 16/06/1447 AH.
//

import SwiftUI

struct HistoryView: View {
    // 🔥 استخدام HistoryStore لقراءة السجل فقط
    @EnvironmentObject var historyStore: HistoryStore
    
    @Environment(\.horizontalSizeClass) private var hSize
    private var isCompact: Bool { hSize == .compact }   // iPhone
    
    // ألوان الخلفية العامة
    private let pageBackground = Color(red: 0.98, green: 0.96, blue: 0.90)
    
    var body: some View {
        ZStack {
            pageBackground.ignoresSafeArea()
            
            VStack(spacing: 16) {
                
                // ————— TITLE —————
                HStack {
                    Text("Meals")
                        .font(isCompact ? .title : .largeTitle)   // ✅ Dynamic Type
                        .fontWeight(.heavy)
                        .foregroundColor(.gray.opacity(0.9))
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                
                // ————— EMPTY STATE / LIST —————
                if historyStore.entries.isEmpty {
                    Spacer()
                    
                    VStack(spacing: 12) {
                        Image(systemName: "tray")
                            .font(.system(size: isCompact ? 36 : 48))
                            .foregroundColor(.gray.opacity(0.6))
                        
                        Text("No items found in the log")
                            .font(.body)   // ✅ Dynamic Type
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(historyStore.entries.reversed()) { entry in
                                MealLargeCard(
                                    type: localizedType(entry.mealTypeTitle),
                                    name: entry.mealName,
                                    carbsText: "\(Int(entry.totalCarbs))g",
                                    insulinText: formatDose(entry.insulinDose),
                                    imageName: fallbackImageName(for: entry.mealTypeTitle),
                                    background: backgroundColor(for: entry.mealTypeTitle),
                                    isCompact: isCompact
                                )
                            }
                        }
                        .padding(.horizontal, isCompact ? 16 : 20)
                        .padding(.top, 8)
                    }
                }
            }
        }
        .environment(\.layoutDirection, .leftToRight)
        .navigationBarHidden(false)
    }
    
    // MARK: - Helpers
    
    private func localizedType(_ type: String) -> String {
        switch type.lowercased() {
        case "breakfast", "فطور": return "Breakfast"
        case "lunch", "غداء": return "Lunch"
        case "dinner", "عشاء": return "Dinner"
        case "snacks", "سناكس": return "Snacks"
        default: return type
        }
    }
    
    private func fallbackImageName(for type: String) -> String {
        switch type.lowercased() {
        case "breakfast", "فطور": return "egg"
        case "lunch", "غداء": return "lunch"
        case "dinner", "عشاء": return "salad"
        case "snacks", "سناكس": return "snacksImg"
        default: return "egg"
        }
    }
    
    private func backgroundColor(for type: String) -> Color {
        switch type.lowercased() {
        case "breakfast", "فطور":
            return Color(red: 1.00, green: 0.98, blue: 0.80)
        case "lunch", "غداء":
            return Color(red: 0.90, green: 0.98, blue: 0.85)
        case "dinner", "عشاء":
            return Color(red: 0.90, green: 0.98, blue: 0.95)
        case "snacks", "سناكس":
            return Color(#colorLiteral(red: 1.00, green: 0.90, blue: 0.95, alpha: 1))
        default:
            return Color.white.opacity(0.9)
        }
    }
    
    private func formatDose(_ dose: Double) -> String {
        if dose.rounded() == dose {
            return String(format: "%.0f", dose)
        } else {
            return String(format: "%.1f", dose)
        }
    }
}

// MARK: - Meal Card

private struct MealLargeCard: View {
    let type: String
    let name: String
    let carbsText: String
    let insulinText: String
    let imageName: String
    let background: Color
    let isCompact: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 36)
                .fill(background)
                .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 6)
                .frame(height: isCompact ? 140 : 170)
                .overlay(
                    RoundedRectangle(cornerRadius: 36)
                        .stroke(Color.white.opacity(0.7), lineWidth: 3)
                )
            
            HStack(spacing: 12) {
                Spacer()
                
                // صورة الوجبة
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: isCompact ? 90 : 150,
                        height: isCompact ? 90 : 150
                    )
                    .padding(.trailing, 12)
                
                // النصوص
                VStack(alignment: .trailing, spacing: 6) {
                    Text(type)
                        .font(isCompact ? .title3 : .largeTitle)   // ✅ Dynamic Type
                        .fontWeight(.heavy)
                        .foregroundColor(.gray.opacity(0.9))
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Name of the meal: \(name)")
                        Text("Carb: \(carbsText)")
                        Text("Insulin dose: \(insulinText)")
                    }
                    .font(.body)   // ✅ Dynamic Type
                    .foregroundColor(.black.opacity(0.7))
                }
                .padding(.trailing, isCompact ? 16 : 24)
                
                Spacer(minLength: 20)
            }
        }
    }
}

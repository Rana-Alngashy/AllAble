//
//  HistoryView.swift
//  AllAble
//
//  Created by Wteen Alghamdy on 16/06/1447 AH.
//
//
import SwiftUI

struct HistoryView: View {
    @StateObject var viewModel: HistoryViewModel
    
    @Environment(\.horizontalSizeClass) private var hSize
    @Environment(\.layoutDirection) var layoutDirection
    
    private var isCompact: Bool { true}
    private var isArabic: Bool { layoutDirection == .rightToLeft }
    
    private let pageBackground = Color(red: 0.98, green: 0.96, blue: 0.90)
    
    // MARK: - Popup State
    @State private var selectedEntry: HistoryEntry?
    @State private var showPopup: Bool = false
    
    var body: some View {
        ZStack {
            pageBackground.ignoresSafeArea()
            
            VStack(spacing: 16) {
                
                // ————— TITLE —————
                HStack {
                    if isArabic { Spacer() }
                    
                    Text("Title.Meals")
                        .font(isCompact ? .title : .largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.gray.opacity(0.9))
                    
                    if !isArabic { Spacer() }
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                
                
                // ————— EMPTY STATE —————
                if viewModel.entries.isEmpty {
                    Spacer()
                    
                    VStack(spacing: 12) {
                        Image(systemName: "tray")
                            .font(.system(size: isCompact ? 36 : 48))
                            .foregroundColor(.gray.opacity(0.6))
                        
                        Text("Title.Meals")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                } else {
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(viewModel.entries.reversed()) { entry in
                                MealLargeCard(
                                    type: localizedType(entry.mealTypeTitle),
                                    imageName: fallbackImageName(for: entry.mealTypeTitle),
                                    background: backgroundColor(for: entry.mealTypeTitle),
                                    date: entry.date,
                                    isCompact: isCompact
                                )
                                .onTapGesture {
                                    selectedEntry = entry
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                                        showPopup = true
                                    }
                                }
                                .accessibilityAddTraits(.isButton)
                                .accessibilityLabel(localizedType(entry.mealTypeTitle))
                            }
                        }
                        .padding(.horizontal, isCompact ? 16 : 20)
                        .padding(.top, 8)
                    }
                }
            }
            .toolbarTitleDisplayMode(.inline)
            
            // ————— POPUP OVERLAY —————
            if showPopup, let entry = selectedEntry {
                PopupDetailView(
                    entry: entry,
                    isArabic: isArabic,
                    isCompact: isCompact,
                    backgroundForType: backgroundColor(for:),
                    onClose: {
                        withAnimation(.easeOut(duration: 0.2)) {
                            showPopup = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            selectedEntry = nil
                        }
                    }
                )
                .transition(.opacity.combined(with: .scale))
            }
        }
        .navigationBarHidden(false)

    }
    
    // MARK: - Helpers
    
    private func localizedType(_ type: String) -> String {
        switch type.lowercased() {
        case "breakfast", NSLocalizedString("Type.Breakfast", comment: "").lowercased():
            return NSLocalizedString("Type.Breakfast", comment: "")
        case "lunch", NSLocalizedString("Type.Lunch", comment: "").lowercased():
            return NSLocalizedString("Type.Lunch", comment: "")
        case "dinner", NSLocalizedString("Type.Dinner", comment: "").lowercased():
            return NSLocalizedString("Type.Dinner", comment: "")
        case "snacks", NSLocalizedString("Type.Snacks", comment: "").lowercased():
            return NSLocalizedString("Type.Snacks", comment: "")
        default:
            return type
        }
    }
    
    private func fallbackImageName(for type: String) -> String {
        switch type.lowercased() {
        case "breakfast", "فطور": return "egg"
        case "lunch", "غداء": return "lunch"
        case "dinner", "عشاء": return "dinnerImg"
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

private struct MealLargeCard: View {
    @Environment(\.layoutDirection) var layoutDirection
    private var isArabic: Bool { layoutDirection == .rightToLeft }
    
    let type: String
    let imageName: String
    let background: Color
    let date: Date
    let isCompact: Bool
    
    // تنسيقات منفصلة للعرض تحت بعض
    private var dateOnlyString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private var timeOnlyString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var body: some View {
        ZStack {
            // Background Card
            RoundedRectangle(cornerRadius: 32)
                .fill(background)
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(Color.white.opacity(0.6), lineWidth: 2)
                )
                .frame(height: isCompact ? 140 : 170)
            
            HStack(spacing: 12) {
                
                if isArabic { Spacer(minLength: 8) }
                
                // Meal Image (by type)
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: isCompact ? 80 : 110,
                           height: isCompact ? 80 : 110)
                    .padding(.horizontal, 6)
                
                // Content Stack: type + date (فوق) + time (تحت)
                VStack(
                    alignment: isArabic ? .trailing : .leading,
                    spacing: 6
                ) {
                    Text(type)
                        .font(isCompact ? .title3.bold() : .title2.bold())
                        .foregroundColor(.gray.opacity(0.85))
                    
                    VStack(alignment: isArabic ? .trailing : .leading, spacing: 0) {
                        Text(dateOnlyString)   // التاريخ فوق
                            .font(isCompact ? .footnote : .callout)
                            .foregroundColor(.gray)
                        Text(timeOnlyString)   // الساعة تحت
                            .font(isCompact ? .footnote : .callout)
                            .foregroundColor(.gray)
                    }
                }
                .padding(isArabic ? .trailing : .leading, 12)
                
                if !isArabic { Spacer(minLength: 8) }
            }
            .padding(.horizontal, 8)
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Popup Detail View
private struct PopupDetailView: View {
    let entry: HistoryEntry
    let isArabic: Bool
    let isCompact: Bool
    let backgroundForType: (String) -> Color
    let onClose: () -> Void
    
    @Environment(\.layoutDirection) var layoutDirection
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.35)
                .ignoresSafeArea()
                .onTapGesture { onClose() }
            
            // Card
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    if isArabic { Spacer() }
                    Text(localizedType(entry.mealTypeTitle))
                        .font(isCompact ? .title3.bold() : .title.bold())
                        .foregroundColor(.gray.opacity(0.9))
                    if !isArabic { Spacer() }
                    
                    Button(action: onClose) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: isCompact ? 22 : 26))
                            .foregroundColor(.gray.opacity(0.7))
                            .accessibilityLabel(Text("Close"))
                    }
                }
                
                // تمت إزالة التاريخ والوقت من داخل الـ pop-up حسب طلبك
                
                // اسم الوجبة
                infoRow(title: NSLocalizedString("MealCard.Name", comment: ""), value: entry.mealName)
                
                // كارب الوجبة الرئيسية (سطر مستقل تحت الاسم) — إن وُجد
                if entry.mainMealCarbs > 0 {
                    infoRow(title: NSLocalizedString("MainMealCarbs", comment: "Main meal carbs"), value: "\(Int(entry.mainMealCarbs))g")
                }
                
                // قائمة الـ Sub Items
                VStack(alignment: .leading, spacing: 8) {
                    Text(NSLocalizedString("Subitems", comment: "Sub Items"))
                        .font(isCompact ? .callout.weight(.semibold) : .title3.weight(.semibold))
                        .foregroundColor(.gray)
                    if entry.subItems.isEmpty {
                        Text(NSLocalizedString("NoSubitems", comment: "No sub items"))
                            .font(isCompact ? .callout : .title3)
                            .foregroundColor(.black.opacity(0.6))
                    } else {
                        ForEach(entry.subItems) { item in
                            HStack(alignment: .firstTextBaseline, spacing: 8) {
                                Text("•")
                                Text(item.name.isEmpty ? "-" : item.name)
                                Spacer(minLength: 8)
                                Text("\(Int(item.carbs))g")
                                    .foregroundColor(.black.opacity(0.75))
                            }
                            .font(isCompact ? .callout : .title3)
                            .foregroundColor(.black.opacity(0.85))
                        }
                    }
                }
                
                // إجمالي الكارب
                infoRow(title: NSLocalizedString("MealCard.Carb", comment: ""), value: "\(Int(entry.totalCarbs))g")
                
                // جرعة الإنسولين
                infoRow(title: NSLocalizedString("MealCard.InsulinDose", comment: ""), value: formatDose(entry.insulinDose))
                
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(backgroundForType(entry.mealTypeTitle)) // اللون حسب نوع الوجبة
                    .shadow(color: .black.opacity(0.15), radius: 16, x: 0, y: 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.6), lineWidth: 2)
                    )
            )
            .padding(.horizontal, isCompact ? 24 : 48)
            .transition(.opacity.combined(with: .scale))
        }
    }
    
    private func infoRow(title: String, value: String) -> some View {
        HStack(spacing: 8) {
            Text(title)
                .foregroundColor(.gray)
                .font(isCompact ? .callout : .title3)
            Text(value)
                .font(isCompact ? .callout.weight(.semibold) : .title3.weight(.semibold))
                .foregroundColor(.black.opacity(0.85))
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func localizedType(_ type: String) -> String {
        switch type.lowercased() {
        case "breakfast", NSLocalizedString("Type.Breakfast", comment: "").lowercased():
            return NSLocalizedString("Type.Breakfast", comment: "")
        case "lunch", NSLocalizedString("Type.Lunch", comment: "").lowercased():
            return NSLocalizedString("Type.Lunch", comment: "")
        case "dinner", NSLocalizedString("Type.Dinner", comment: "").lowercased():
            return NSLocalizedString("Type.Dinner", comment: "")
        case "snacks", NSLocalizedString("Type.Snacks", comment: "").lowercased():
            return NSLocalizedString("Type.Snacks", comment: "")
        default:
            return type
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

#Preview {
    let store = HistoryStore()
    let viewModel = HistoryViewModel(store: store)
    
    return HistoryView(viewModel: viewModel)
}

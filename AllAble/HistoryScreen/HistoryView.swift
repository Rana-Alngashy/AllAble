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
    
    private var isCompact: Bool { true }
    private var isArabic: Bool { layoutDirection == .rightToLeft }
    
    // خلفية عامة بيج فاتح
    private let pageBackground = Color(red: 0.98, green: 0.96, blue: 0.90)
    
    // MARK: - Sheet State
    @State private var selectedEntry: HistoryEntry?
    
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
                        VStack(spacing: 16) {
                            ForEach(viewModel.entries.reversed()) { entry in
                                MealLargeCard(
                                    type: localizedType(entry.mealTypeTitle),
                                    imageName: fallbackImageName(for: entry.mealTypeTitle),
                                    background: backgroundColor(for: entry.mealTypeTitle), // ← لون حسب النوع
                                    date: entry.date,
                                    isCompact: isCompact
                                )
                                .onTapGesture {
                                    selectedEntry = entry
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
        }
        .navigationBarHidden(false)
        // ————— SHEET PRESENTATION —————
        .sheet(item: $selectedEntry) { entry in
            HistoryDetailSheet(
                entry: entry,
                isArabic: isArabic,
                isCompact: isCompact,
                onClose: { selectedEntry = nil }
            )
            .presentationDetents([.large]) // يبدأ الشيت من الأعلى
            .presentationDragIndicator(.hidden) // لإخفاء مؤشر السحب
        }
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
            return Color(#colorLiteral(red: 1.00, green: 0.98, blue: 0.80, alpha: 1))
        case "lunch", "غداء":
            return Color(#colorLiteral(red: 0.85, green: 1.00, blue: 0.85, alpha: 1))
        case "dinner", "عشاء":
            // طابق لون "Dinner" مع AddMealViewModel
            return Color(#colorLiteral(red: 0.85, green: 0.95, blue: 1.00, alpha: 1))
        case "snacks", "سناكس":
            return Color(#colorLiteral(red: 1.00, green: 0.90, blue: 0.95, alpha: 1))
        default:
            return Color.white.opacity(0.9)
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
    
    private var dateTimeString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.dateFormat = "MMM d, yyyy — h:mm a"
        return formatter.string(from: date)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(background) // ← لون حسب النوع
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.6), lineWidth: 2)
                )
                .frame(height: isCompact ? 120 : 150)
            
            HStack(spacing: 12) {
                
                if isArabic { Spacer(minLength: 8) }
                
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: isCompact ? 70 : 95,
                           height: isCompact ? 70 : 95)
                    .padding(.horizontal, 6)
                
                VStack(
                    alignment: isArabic ? .trailing : .leading,
                    spacing: 6
                ) {
                    Text(type)
                        .font(isCompact ? .title3.bold() : .title2.bold())
                        .foregroundColor(.gray.opacity(0.85))
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                    
                    HStack(spacing: 8) {
                        Image(systemName: "calendar")
                            .foregroundColor(.gray.opacity(0.7))
                        Text(dateTimeString)
                            .font(isCompact ? .footnote : .callout)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }
                }
                .padding(isArabic ? .trailing : .leading, 8)
                
                if !isArabic { Spacer(minLength: 8) }
            }
            .padding(.horizontal, 10)
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - History Detail Sheet (خلفية الشيت فقط بدون بطاقة داخلية)
private struct HistoryDetailSheet: View {
    let entry: HistoryEntry
    let isArabic: Bool
    let isCompact: Bool
    let onClose: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    // نجعل خلفية الشيت نفس خلفية الشاشة الرئيسية
    private let sheetBackground = Color(red: 0.98, green: 0.96, blue: 0.90)
    private let cardStroke = Color.gray.opacity(0.35)
    private let titleColor = Color.gray.opacity(0.7)
    
    var body: some View {
        VStack(spacing: 18) {
            // صف العنوان مع زر الإغلاق "x" فقط
            HStack {
                CircleButton(systemName: "xmark", action: close)
                
                Spacer()
                
                Text(localizedType(entry.mealTypeTitle))
                    .foregroundColor(titleColor)
                    .font(isCompact ? .title3 : .title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                // توازن بصري مكان زر الصح المحذوف
                Spacer().frame(width: 36, height: 36)
            }
            .padding(.horizontal, 18)
            .padding(.top, 14)
            
            // الحقل الرئيسي (اسم + كارب الوجبة)
            InputGroup {
                LabeledField(title: "Name of the meal:", value: entry.mealName)
                Divider().overlay(cardStroke)
                LabeledField(title: "Main Meal Carbs :", value: entry.mainMealCarbs > 0 ? "\(Int(entry.mainMealCarbs))" : "-")
            }
            
            // لا تعرض قسم Subitems إلا إذا كانت هناك عناصر فرعية
            if entry.subItems.isEmpty == false {
                // عنوان Subitems
                HStack {
                    Text("Subitems")
                        .font(isCompact ? .title3 : .title2)
                        .foregroundColor(titleColor)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding(.horizontal, 6)
                
                // مجموعة لكل عنصر فرعي
                VStack(spacing: 12) {
                    ForEach(entry.subItems) { item in
                        InputGroup {
                            LabeledField(title: "Name of the meal:", value: item.name.isEmpty ? "-" : item.name)
                            Divider().overlay(cardStroke)
                            LabeledField(title: "Carbs :", value: "\(Int(item.carbs) ?? 0)")
                        }
                    }
                }
            }
            
            // حقول مفصولة بسيطة (Carbs, Insulin dose) مع وحدات
            SimpleField(title: "Carbs:", value: "\(Int(entry.totalCarbs)) g")
            SimpleField(title: "Insulin dose:", value: "\(formatDose(entry.insulinDose)) U")
            
            Spacer(minLength: 4)
        }
        .padding(.top, 8)
        .padding(.horizontal, 12)
        .background(sheetBackground.ignoresSafeArea())
    }
    
    private func close() {
        dismiss()
        onClose()
    }
    
    // MARK: - Subviews
    
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
    
    // تنسيق جرعة الإنسولين (عرض 3 كـ "3" و 3.5 كـ "3.5")
    private func formatDose(_ dose: Double) -> String {
        if dose.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", dose)
        } else {
            return String(format: "%.1f", dose)
        }
    }
    
    private struct CircleButton: View {
        let systemName: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                        .frame(width: 36, height: 36)
                    Image(systemName: systemName)
                        .foregroundColor(.gray.opacity(0.7))
                        .font(.system(size: 16, weight: .semibold))
                }
            }
            .buttonStyle(.plain)
        }
    }
    
    private struct InputGroup<Content: View>: View {
        @ViewBuilder var content: Content
        
        var body: some View {
            VStack(spacing: 0) { content }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
                )
                .padding(.horizontal, 6)
        }
    }
    
    private struct LabeledField: View {
        let title: String
        let value: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .foregroundColor(.gray.opacity(0.9))
                    .font(.callout)
                Text(value.isEmpty ? "-" : value)
                    .foregroundColor(.black.opacity(0.8))
                    .font(.callout.weight(.semibold))
            }
        }
    }
    
    private struct SimpleField: View {
        let title: String
        let value: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .foregroundColor(.gray.opacity(0.75))
                    .font(.callout)
                
                Text(value.isEmpty ? "-" : value)
                    .foregroundColor(.black.opacity(0.8))
                    .font(.callout.weight(.semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 26)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 26)
                                    .stroke(Color.gray.opacity(0.45), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.06), radius: 5, x: 0, y: 2)
                    )
            }
            .padding(.horizontal, 6)
        }
    }
}

#Preview {
    let store = HistoryStore()
    let viewModel = HistoryViewModel(store: store)
    return HistoryView(viewModel: viewModel)
}

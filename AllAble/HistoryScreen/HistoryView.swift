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
                        .foregroundColor(.black)
                    
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
                            .foregroundColor(.black)
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

// MARK: - Updated History Detail Sheet
private struct HistoryDetailSheet: View {
    let entry: HistoryEntry
    let isArabic: Bool
    let isCompact: Bool
    let onClose: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    private let sheetBackground = Color(red: 0.98, green: 0.96, blue: 0.90)
    private let primaryBlack = Color.black
    private let secondaryBlack = Color.black.opacity(0.7)
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // ————— MAIN MEAL SECTION —————
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(title: "Meal Details")
                        
                        InputGroup {
                            LabeledField(title: "Name of the meal", value: entry.mealName)
                            Divider().background(primaryBlack.opacity(0.1))
                            LabeledField(title: "Main Meal Carbs", value: entry.mainMealCarbs > 0 ? "\(Int(entry.mainMealCarbs)) g" : "-")
                        }
                    }
                    
                    // ————— SUBITEMS SECTION —————
                    if !entry.subItems.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Subitems")
                            
                            VStack(spacing: 12) {
                                ForEach(entry.subItems) { item in
                                    InputGroup {
                                        LabeledField(title: "Item Name", value: item.name.isEmpty ? "-" : item.name)
                                        Divider().background(primaryBlack.opacity(0.1))
                                        LabeledField(title: "Carbs", value: "\(Int(item.carbs) ?? 0) g")
                                    }
                                }
                            }
                        }
                    }
                    
                    // ————— TOTALS SECTION —————
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            SummaryCard(title: "Total Carbs", value: "\(Int(entry.totalCarbs)) g", icon: "fork.knife")
                            SummaryCard(title: "Insulin Dose", value: "\(formatDose(entry.insulinDose)) U", icon: "drop.fill")
                        }
                    }
                    
                    Spacer(minLength: 30)
                }
                .padding()
            }
            .background(sheetBackground.ignoresSafeArea())
            .navigationTitle(localizedType(entry.mealTypeTitle))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        close()
                    }
                    .fontWeight(.bold)
                    .foregroundColor(primaryBlack)
                }
            }
        }
    }
    
    private func close() {
        dismiss()
        onClose()
    }
    
    // MARK: - Helpers & Subviews
    
    private func localizedType(_ type: String) -> String {
        let key = "Type.\(type.capitalized)"
        let localized = NSLocalizedString(key, comment: "")
        return localized.contains("Type.") ? type : localized
    }

    private func formatDose(_ dose: Double) -> String {
        dose.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", dose) : String(format: "%.1f", dose)
    }

    private struct SectionHeader: View {
        let title: String
        var body: some View {
            Text(title.uppercased())
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.black.opacity(0.6))
                .padding(.leading, 8)
        }
    }

    private struct InputGroup<Content: View>: View {
        @ViewBuilder var content: Content
        var body: some View {
            VStack(alignment: .leading, spacing: 12) { content }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.black, lineWidth: 1.2)
                )
        }
    }
    
    private struct LabeledField: View {
        let title: String
        let value: String
        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.black.opacity(0.5))
                Text(value)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
        }
    }

    private struct SummaryCard: View {
        let title: String
        let value: String
        let icon: String
        var body: some View {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .font(.caption2)
                    .fontWeight(.medium)
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.black, lineWidth: 1.2)
            )
        }
    }
}
#Preview {
    let store = HistoryStore()
    let viewModel = HistoryViewModel(store: store)
    return HistoryView(viewModel: viewModel)
}

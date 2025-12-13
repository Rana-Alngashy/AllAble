//
//  CarbRatioPage.swift
//  AllAble
//
//  Created by Wteen Alghamdy on 18/06/1447 AH.
//

import SwiftUI

struct CarbRatioPage: View {
    @EnvironmentObject var store: CarbRatioStore
    @StateObject var viewModel: CarbRatioViewModel
    @Environment(\.dismiss) private var dismiss
    
    // 🔥 لإغلاق الـ Onboarding والانتقال إلى MainPage
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    let isFirstTimeOnboarding: Bool

    @Environment(\.horizontalSizeClass) private var hSize
    private var isCompact: Bool { true }
    
    let customYellow = Color(red: 0.99, green: 0.85, blue: 0.33)
    let customBackground = Color(red: 0.97, green: 0.96, blue: 0.92)

    init(store: CarbRatioStore, isFirstTimeOnboarding: Bool) {
        // نستخدم injected store للتهيئة
        _viewModel = StateObject(wrappedValue: CarbRatioViewModel(store: store))
        self.isFirstTimeOnboarding = isFirstTimeOnboarding
    }

    var body: some View {
        ZStack {
            customBackground.ignoresSafeArea()

            VStack {
                // ————— TITLE & DISMISS BUTTON —————
                headerSection

                ScrollView {
                    VStack(alignment: .leading, spacing: isCompact ? 30 : 50) {
                        
                        defaultRatioSection
                        addNewRatioSection
                        customRatiosList
                        
                        Spacer()
                    }
                    .padding(.horizontal, isCompact ? 20 : 50)
                    .padding(.vertical, isCompact ? 10 : 30)
                }
                
                // ————— زر المتابعة/الحفظ —————
                Group {
                    if isFirstTimeOnboarding {
                        OnboardingNextButton
                    } else {
                        DismissButton
                    }
                }
                .padding(.horizontal, isCompact ? 20 : 40)
                .padding(.bottom, isCompact ? 20 : 50)
            }
        }
        .navigationBarHidden(true)
        .environment(\.layoutDirection, .leftToRight)
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(.black.opacity(0.7))
            }
            .padding(.leading, isCompact ? 20 : 50)

            Spacer()

            Text("Title.CarbRatioSettings")
                .font(isCompact ? .title2 : .largeTitle)
                .bold()
                .foregroundColor(.black.opacity(0.8))
                .multilineTextAlignment(.center)

            Spacer()
            
            Button(action: { }) {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(.clear)
            }
            .padding(.trailing, isCompact ? 20 : 50)
        }
        .padding(.vertical, 10)
        .background(Color.white.opacity(0.8).ignoresSafeArea(edges: .top))
        .shadow(color: .gray.opacity(0.3), radius: 2, y: 1)
    }

    // MARK: - Sections (Default Ratio, Add New, List)

    private var defaultRatioSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(store.defaultRatio.name)
                .font(isCompact ? .headline : .title2)
                .bold()
                .foregroundColor(.black.opacity(0.8))

            HStack {
                Text("Ratio Value:")
                    .font(.body)
                    .foregroundColor(.gray)

                // ✅ هنا يتم ربط الحقل مباشرة بقيمة النسبة الافتراضية القابلة للتعديل
                TextField("", value: Binding(
                    get: { store.defaultRatio.ratio },
                    set: { viewModel.updateDefaultRatioValue(newValue: $0) }
                ), formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 100)
                    .font(.body.bold())
                
                Text("g/unit")
                    .font(.body)
                    .foregroundColor(.gray)

                Spacer()
            }
            .padding(15)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 3)
        }
    }

    private var addNewRatioSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Add New Ratio")
                .font(isCompact ? .headline : .title2)
                .bold()
                .foregroundColor(.black.opacity(0.8))
            
            VStack(spacing: 15) {
                InputField(label: NSLocalizedString("Label.RatioName", comment: ""), text: $viewModel.newRatioName)
                
                InputField(label: "Ratio Value", text: $viewModel.newRatioValue)
                    .keyboardType(.decimalPad)
                
                Button(action: viewModel.addRatio) {
                    Text("Button.Save")
                        .font(isCompact ? .body : .title3)
                        .bold()
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(viewModel.isAddButtonEnabled ? customYellow : Color.gray.opacity(0.3))
                        .cornerRadius(12)
                }
                .disabled(!viewModel.isAddButtonEnabled)
            }
            .padding(15)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 3)
        }
    }
    
    private var customRatiosList: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Other Custom Ratios")
                .font(isCompact ? .headline : .title2)
                .bold()
                .foregroundColor(.black.opacity(0.8))
            
            // تصفية النسبة الافتراضية
            let customRatios = store.ratios.filter { $0.id != store.defaultRatio.id }

            if customRatios.isEmpty {
                Text("No custom ratios added yet.")
                    .foregroundColor(.gray)
                    .padding(.top, 5)
            } else {
                ForEach(customRatios) { entry in
                    RatioCardView(entry: entry, customYellow: customYellow) {
                        viewModel.deleteRatio(entry: entry)
                    }
                }
            }
        }
    }

    // MARK: - Navigation Buttons
    
    private var OnboardingNextButton: some View {
        Button(action: {
            // 🔥 مسار التسجيل النهائي: إكمال الـ Onboarding والانتقال إلى MainPage
            hasCompletedOnboarding = true
        }) {
            Text("Button.Next")
                .font(isCompact ? .title3 : .title2)
                .bold()
                .frame(maxWidth: .infinity)
                .frame(height: isCompact ? 50 : 60)
                .background(customYellow)
                .foregroundColor(.black)
                .cornerRadius(15)
        }
    }
    
    private var DismissButton: some View {
        Button(action: {
            dismiss() // العودة إلى الصفحة السابقة (عادةً MainPage)
        }) {
            Text("Button.Done")
                .font(isCompact ? .title3 : .title2)
                .bold()
                .frame(maxWidth: .infinity)
                .frame(height: isCompact ? 50 : 60)
                .background(customYellow)
                .foregroundColor(.black)
                .cornerRadius(15)
        }
    }
    
    // MARK: - Helper Views (InputField, RatioCardView)

    struct InputField: View {
        let label: String
        @Binding var text: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(label)
                    .font(.callout)
                    .foregroundColor(.gray)
                
                TextField("", text: $text)
                    .padding(10)
                    .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
            }
        }
    }
    
    struct RatioCardView: View {
        let entry: CarbRatioEntry
        let customYellow: Color
        let onDelete: () -> Void
        
        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(entry.name)
                        .font(.headline)
                        .foregroundColor(.black.opacity(0.9))
                    Text("\(String(format: "%.1f", entry.ratio)) g/unit")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: onDelete) {
                    Image(systemName: "trash.fill")
                        .foregroundColor(.red)
                        .padding(8)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 3)
        }
    }
}

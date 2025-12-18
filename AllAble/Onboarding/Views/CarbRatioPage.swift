//
//  CarbRatioPage.swift
//  AllAble
//
//  Created by Wteen Alghamdy on 18/06/1447 AH.
//
// CarbRatioPage.swift

import SwiftUI

struct CarbRatioPage: View {
    @EnvironmentObject var store: CarbRatioStore
    @StateObject var viewModel: CarbRatioViewModel
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    let isFirstTimeOnboarding: Bool

    @Environment(\.horizontalSizeClass) private var hSize
    private var isCompact: Bool { true }
    
    let customYellow = Color(red: 0.99, green: 0.85, blue: 0.33)
    let customBackground = Color(red: 0.97, green: 0.96, blue: 0.92)
    
    // ✅ الحل: String وسيط للإدخال
    @State private var defaultRatioText: String = ""

    init(store: CarbRatioStore, isFirstTimeOnboarding: Bool) {
        _viewModel = StateObject(wrappedValue: CarbRatioViewModel(store: store))
        self.isFirstTimeOnboarding = isFirstTimeOnboarding
    }

    var body: some View {
        ZStack {
            customBackground.ignoresSafeArea()

            VStack {
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
        .onAppear {
            // تحميل القيمة الحالية كنص
            defaultRatioText = String(format: "%.0f", store.defaultRatio.ratio)
        }
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

            Spacer()

            Image(systemName: "xmark")
                .foregroundColor(.clear)
                .padding(.trailing, isCompact ? 20 : 50)
        }
        .padding(.vertical, 10)
        .background(Color.white.opacity(0.8))
        .shadow(color: .gray.opacity(0.3), radius: 2, y: 1)
    }

    // MARK: - Default Ratio
    private var defaultRatioSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(store.defaultRatio.name)
                .font(isCompact ? .headline : .title2)
                .bold()

            HStack {
                Text("Ratio Value:")
                    .foregroundColor(.gray)

                TextField("", text: $defaultRatioText)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 100)
                    .font(.body.bold())
                    .onChange(of: defaultRatioText) { newValue in
                        // تحديث فقط إذا القيمة صالحة
                        if let value = Double(newValue), value > 0 {
                            viewModel.updateDefaultRatioValue(newValue: value)
                        }
                    }

                Text("g/unit")
                    .foregroundColor(.gray)

                Spacer()
            }
            .padding(15)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 3)
        }
    }

    // MARK: - Add New Ratio
    private var addNewRatioSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Add New Ratio")
                .font(isCompact ? .headline : .title2)
                .bold()
            
            VStack(spacing: 15) {
                InputField(label: "Ratio Name", text: $viewModel.newRatioName)
                InputField(label: "Ratio Value", text: $viewModel.newRatioValue)
                    .keyboardType(.decimalPad)
                
                Button(action: viewModel.addRatio) {
                    Text("Save")
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

    // MARK: - Custom Ratios List
    private var customRatiosList: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Other Custom Ratios")
                .font(isCompact ? .headline : .title2)
                .bold()
            
            if store.ratios.isEmpty {
                Text("No custom ratios added yet.")
                    .foregroundColor(.gray)
            } else {
                ForEach(store.ratios) { entry in
                    RatioCardView(entry: entry, onDelete: {
                        viewModel.deleteRatio(entry: entry)
                    })
                }
            }
        }
    }

    // MARK: - Buttons
    private var OnboardingNextButton: some View {
        Button(action: { hasCompletedOnboarding = true }) {
            Text("Next")
                .bold()
                .frame(maxWidth: .infinity, minHeight:  50)
                .background(customYellow)
                .cornerRadius(15)
        }
    }

    private var DismissButton: some View {
        Button(action: { dismiss() }) {
            Text("Done")
                .bold()
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, minHeight:  50)
                .background(customYellow)
                .cornerRadius(15)
        }
    }

    // MARK: - Helper Views
    struct InputField: View {
        let label: String
        @Binding var text: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(label)
                    .foregroundColor(.gray)
                TextField("", text: $text)
                    .padding(10)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
        }
    }

    struct RatioCardView: View {
        let entry: CarbRatioEntry
        let onDelete: () -> Void
        
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(entry.name).bold()
                    Text("\(entry.ratio, specifier: "%.1f") g/unit")
                        .foregroundColor(.gray)
                }
                Spacer()
                Button(action: onDelete) {
                    Image(systemName: "trash.fill")
                        .foregroundColor(.red)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
        }
    }
}

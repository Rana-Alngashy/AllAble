//
//  EditMealView.swift
//  AllAble
//
//  Created by lamess on 10/06/1447 AH.


import SwiftUI

struct EditMealView: View {
    @EnvironmentObject var router: NotificationRouter
    @EnvironmentObject var carbRatioStore: CarbRatioStore
    
    let meal: MealItem
    @StateObject var viewModel = MealContentViewModel()
    
    // ✅ ملاحظة: CarbRatioEntry أصبح الآن Hashable
    @State private var selectedCarbRatio: CarbRatioEntry
    
    @State private var navigateToCalculateView = false
    
    @Environment(\.horizontalSizeClass) private var hSize
    private var isCompact: Bool { true }
    
    // تهيئة القيمة الافتراضية
    init(meal: MealItem, carbRatioStore: CarbRatioStore = CarbRatioStore()) {
        self.meal = meal
        // نختار النسبة الافتراضية من الـ Store
        _selectedCarbRatio = State(initialValue: carbRatioStore.defaultRatio)
    }
    
    var body: some View {
        
        ZStack {
            Color(#colorLiteral(red: 0.97, green: 0.96, blue: 0.92, alpha: 1))
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: isCompact ? 24 : 40) {
                    
                    // ————— TITLE —————
                    Text("Title.MealContents")
                        .font(.system(size: isCompact ? 26 : 40, weight: .bold))
                        .foregroundColor(.gray.opacity(0.9))
                        .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                            .padding(.top, isCompact ? 10 : 20)
                    
                    // ————— CARB RATIO SELECTOR —————
                    carbRatioSelector
                    
                    // ————— MAIN MEAL INFO —————
                    VStack(alignment: .leading, spacing: 25) {
                        
                        Text("Label.MainMeal")
                            .font(isCompact ? .title3 : .title2)
                            .bold()
                        
                        // Meal Name
                        TextField(LocalizedStringKey("Placeholder.MealName"), text: $viewModel.mealName)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                        
                        // Carbs
                        HStack {
                            TextField(LocalizedStringKey("Placeholder.Carbs"), text: $viewModel.mealCarbs)
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                            
                            Text("g")
                                .font(.title3.bold())
                                .foregroundColor(.gray.opacity(0.8))
                        }
                    }
                    
                    // ————— SUB ITEMS SECTION —————
                    subItemsSection
                    
                    // ————— TOTAL CARBS —————
                    totalCarbsSection
                    
                    Spacer(minLength: isCompact ? 20 : 40)
                    
                    // ————— BUTTON —————
                    Button(action: {
                        navigateToCalculateView = true
                    }) {
                        Text("Button.CalculateInsulin")
                            .font(isCompact ? .title3 : .title3)
                            .bold()
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(#colorLiteral(red: 0.99, green: 0.85, blue: 0.33, alpha: 1)))
                            .cornerRadius(14)
                    }
                }
                .padding(.horizontal, isCompact ? 20 : 50)
                .padding(.top, isCompact ? 20 : 40)
            }
            .navigationDestination(isPresented: $navigateToCalculateView) {
                CalculateView(
                    totalCarbs: viewModel.totalCarbs,
                    mealName: viewModel.mealName.isEmpty ? meal.title : viewModel.mealName,
                    mealType: meal.title,
                    mainMealCarbs: Double(Int(viewModel.mealCarbs) ?? 0),
                    subItems: viewModel.subItems,
                    carbRatioEntry: selectedCarbRatio
                )
            }
        }
        .toolbarTitleDisplayMode(.inline)
        .environment(\.layoutDirection, .leftToRight)
        
    }
    
    // MARK: - Carb Ratio Selector (جديد)
    private var carbRatioSelector: some View {
        VStack(alignment: .leading) {
            Text("Label.ChildCarbRatio")
                .font(isCompact ? .title3 : .title2)
                .bold()
            
            // ✅ يعمل الآن لأن CarbRatioEntry متوافق مع Hashable
            Picker(selection: $selectedCarbRatio, label: Text("Choose Ratio")) {
                ForEach(carbRatioStore.ratios) { ratioEntry in
                    Text("\(ratioEntry.name) (\(String(format: "%.1f", ratioEntry.ratio)) g/unit)")
                        .tag(ratioEntry)
                }
            }
            .pickerStyle(.menu)
            .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 3)
        }
    }

    // ... (بقية الكود)
    private var subItemsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            HStack {
                Text("Label.SubItems")
                    .font(isCompact ? .title3 : .title3)
                    .bold()
                Spacer()
                
                Button(action: {
                    viewModel.addSubItem()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: isCompact ? 26 : 30))
                        .foregroundColor(.yellow)
                }
            }
            
            ForEach($viewModel.subItems) { $item in
                HStack(spacing: 15) {
                    TextField(LocalizedStringKey("Placeholder.MealName"), text: $item.name)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    
                    HStack {
                        TextField(LocalizedStringKey("Placeholder.Carbs"), text: $item.carbs)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                        
                        Text("g")
                            .font(.title3.bold())
                            .foregroundColor(.gray.opacity(0.8))
                    }
                    .frame(width: isCompact ? 140 : 200)
                }
            }
            
            Button("Add Another Item") {
                viewModel.addSubItem()
            }
            .font(isCompact ? .body : .title3)
            .bold()
            .foregroundColor(.gray.opacity(0.8))
            .padding(.top, 10)
        }
    }
    
    private var totalCarbsSection: some View {
        HStack {
            Text("TotalCarbs")
                .font(isCompact ? .title2 : .largeTitle)
                .bold()
            
            Spacer()
            
            Text("\(viewModel.totalCarbs)")
                .font(isCompact ? .title2 : .largeTitle)
                .bold()
                .foregroundColor(Color(#colorLiteral(red: 0.99, green: 0.85, blue: 0.33, alpha: 1)))
            
            Text("g")
                .font(isCompact ? .title2 : .largeTitle)
                .bold()
                .foregroundColor(.gray.opacity(0.8))
        }
        .padding(.top, isCompact ? 10 : 20)
    }
}

























////
//import SwiftUI
//
//struct EditMealView: View {
//    @EnvironmentObject var router: NotificationRouter
//    let meal: MealItem
//    @StateObject var viewModel = MealContentViewModel()
//    
//    @State private var navigateToCalculateView = false
//    
//    @Environment(\.horizontalSizeClass) private var hSize
//    private var isCompact: Bool { true }
//    
//    var body: some View {
//        
//        ZStack {
//            Color(#colorLiteral(red: 0.97, green: 0.96, blue: 0.92, alpha: 1))
//                .ignoresSafeArea()
//            
//            ScrollView {
//                VStack(alignment: .leading, spacing: isCompact ? 24 : 40) {
//                    
//                    // ————— TITLE —————
//                    Text("Title.MealContents")
//                        .font(.system(size: isCompact ? 26 : 40, weight: .bold))
//                        .foregroundColor(.gray.opacity(0.9))
//                        .padding(.leading, 8)
//                    
//                    // ————— MAIN MEAL INFO —————
//                    VStack(alignment: .leading, spacing: 25) {
//                        
//                        Text("Label.MainMeal")
//                            .font(isCompact ? .title3 : .title2)
//                            .bold()
//                        
//                        TextField(LocalizedStringKey("Placeholder.MealName"), text: $viewModel.mealName)
//                            .padding()
//                            .background(.white)
//                            .cornerRadius(14)
//                        
//                        TextField(LocalizedStringKey("Placeholder.Carbs"), text: $viewModel.mealCarbs)
//                            .keyboardType(.numberPad)
//                            .padding()
//                            .background(.white)
//                            .cornerRadius(14)
//                    }
//                    
//                    // ————— SUB ITEMS —————
//                    VStack(alignment: .leading, spacing: 20) {
//                        
//                        HStack {
//                            Text("Add Sub Items")
//                                .font(isCompact ? .title3 : .title3)
//                                .bold()
//                            Spacer()
//                            
//                            Button(action: {
//                                viewModel.addSubItem()
//                            }) {
//                                Image(systemName: "plus.circle.fill")
//                                    .font(.system(size: isCompact ? 26 : 30))
//                                    .foregroundColor(.yellow)
//                            }
//                        }
//                        
//                        ForEach($viewModel.subItems) { $item in
//                            VStack(spacing: 12) {
//                                TextField(LocalizedStringKey("Placeholder.MealName"), text: $item.name)
//                                    .padding()
//                                    .background(.white)
//                                    .cornerRadius(12)
//                                
//                                TextField(LocalizedStringKey("Placeholder.Carbs"), text: $item.carbs)
//                                    .keyboardType(.numberPad)
//                                    .padding()
//                                    .background(.white)
//                                    .cornerRadius(12)
//                            }
//                        }
//                    }
//                    
//                    // ————— TOTAL CARBS —————
//                    Text("\(NSLocalizedString("TotalCarbs", comment: "")) \(viewModel.totalCarbs)")
//                        .font(isCompact ? .title3 : .title2)
//                        .bold()
//                        .foregroundColor(.black.opacity(0.7))
//                    
//                    Spacer(minLength: isCompact ? 20 : 40)
//                    
//                    // ————— BUTTON —————
//                    Button(action: {
//                        navigateToCalculateView = true
//                    }) {
//                        Text("Button.CalculateInsulin")
//                            .font(isCompact ? .title3 : .title3)
//                            .bold()
//                            .foregroundColor(.black)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color(#colorLiteral(red: 0.99, green: 0.85, blue: 0.33, alpha: 1)))
//                            .cornerRadius(14)
//                    }
//                }
//                .padding(.horizontal, isCompact ? 20 : 50)
//                .padding(.top, isCompact ? 20 : 40)
//            }
//            .navigationDestination(isPresented: $navigateToCalculateView) {
//                CalculateView(
//                    totalCarbs: viewModel.totalCarbs,
//                    mealName: viewModel.mealName.isEmpty ? meal.title : viewModel.mealName,
//                    mealType: meal.title,
//                    mainMealCarbs: Double(Int(viewModel.mealCarbs) ?? 0),   // ← تمرير كارب الوجبة الرئيسية
//                    subItems: viewModel.subItems                             // ← تمرير العناصر الفرعية
//                )
//            }
//        }
//        .toolbarTitleDisplayMode(.inline)
//        .environment(\.layoutDirection, .leftToRight)
//    }
//}
//

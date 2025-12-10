
//
//  EditMealView.swift
//  AllAble
//
//  Created by lamess on 10/06/1447 AH.
//
import SwiftUI

struct EditMealView: View {
    @EnvironmentObject var router: NotificationRouter
    let meal: MealItem
    @StateObject var viewModel = MealContentViewModel()
    
    @State private var navigateToCalculateView = false
    
    @Environment(\.horizontalSizeClass) private var hSize
    private var isCompact: Bool { true }
    
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
                        .padding(.leading, 8)
                    
                    // ————— MAIN MEAL INFO —————
                    VStack(alignment: .leading, spacing: 25) {
                        
                        Text("Label.MainMeal")
                            .font(isCompact ? .title3 : .title2)
                            .bold()
                        
                        TextField(LocalizedStringKey("Placeholder.MealName"), text: $viewModel.mealName)
                            .padding()
                            .background(.white)
                            .cornerRadius(14)
                        
                        TextField(LocalizedStringKey("Placeholder.Carbs"), text: $viewModel.mealCarbs)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(.white)
                            .cornerRadius(14)
                    }
                    
                    // ————— SUB ITEMS —————
                    VStack(alignment: .leading, spacing: 20) {
                        
                        HStack {
                            Text("Add Sub Items")
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
                            VStack(spacing: 12) {
                                TextField(LocalizedStringKey("Placeholder.MealName"), text: $item.name)
                                    .padding()
                                    .background(.white)
                                    .cornerRadius(12)
                                
                                TextField(LocalizedStringKey("Placeholder.Carbs"), text: $item.carbs)
                                    .keyboardType(.numberPad)
                                    .padding()
                                    .background(.white)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    
                    // ————— TOTAL CARBS —————
                    Text("\(NSLocalizedString("TotalCarbs", comment: "")) \(viewModel.totalCarbs)")
                        .font(isCompact ? .title3 : .title2)
                        .bold()
                        .foregroundColor(.black.opacity(0.7))
                    
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
                    mealType: meal.title
                )
            }
        }
        .toolbarTitleDisplayMode(.inline)
        .environment(\.layoutDirection, .leftToRight)   // ←←✨ أهم شيء: إجبار اليسار حتى لو الجهاز عربي
    }
}

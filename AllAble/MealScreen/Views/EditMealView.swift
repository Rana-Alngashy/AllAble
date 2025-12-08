//
//  EditMealView.swift
//  AllAble
//
//  Created by lamess on 10/06/1447 AH.
//
//import SwiftUI
//
//struct EditMealView: View {
//
//    let meal: MealItem
//
//    var body: some View {
//        VStack(spacing: 30) {
//
//            Text("Editing: \(meal.title)")
//                .font(.largeTitle)
//                .bold()
//
//            Image(meal.imageName)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 200, height: 300)
//                .clipShape(RoundedRectangle(cornerRadius: 20))
//
//            Spacer()
//        }
//        .padding()
//    }
//}
//#Preview {
//    EditMealView(
//        meal: MealItem(
//            title: "Lunch",
//            imageName: "lunch",
//            color: Color.yellow.opacity(0.3)
//        )
//    )
//}










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
    
    // 1. State variable to trigger navigation to CalculateView
    @State private var navigateToCalculateView = false
    @Environment(\.horizontalSizeClass) private var hSize
       private var isCompact: Bool { hSize == .compact }   // iPhone
       
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.97, green: 0.96, blue: 0.92, alpha: 1))
                .ignoresSafeArea()
            ScrollView {
            VStack(alignment: .leading, spacing: isCompact ? 24 : 40) {
                
                // ————— TITLE —————
                Text("Meal Contents")
                    .font(.system(size: isCompact ? 26 : 40, weight: .bold))
                    .foregroundColor(.gray.opacity(0.9))
                
                // ————— MAIN MEAL INFO —————
                VStack(alignment: .leading, spacing: 25) {
                    
                    Text("Main Meal")
                        .font(isCompact ? .title3 : .title2)
                        .bold()
                    
                    TextField("Meal name", text: $viewModel.mealName)
                        .padding()
                        .background(.white)
                        .cornerRadius(14)
                    
                    TextField("Carbs", text: $viewModel.mealCarbs)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(.white)
                        .cornerRadius(14)
                        .font(.body)
                    
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
                            TextField("Item name", text: $item.name)
                                .padding()
                                .background(.white)
                                .cornerRadius(12)
                                .font(.body)
                            
                            TextField("Carbs", text: $item.carbs)
                                .keyboardType(.numberPad)
                                .padding()
                                .background(.white)
                                .cornerRadius(12)
                                .font(.body)
                            
                        }
                    }
                    
                }
                
                // ————— TOTAL CARBS —————
                Text("Total carbs: \(viewModel.totalCarbs)")
                    .font(isCompact ? .title3 : .title2)
                    .bold()
                    .foregroundColor(.black.opacity(0.7))
                
                Spacer(minLength: isCompact ? 20 : 40)
                
                // ————— BUTTON —————
                Button(action: {
                    print("Final total carbs =", viewModel.totalCarbs)
                    // 2. Set state to true to trigger navigation
                    navigateToCalculateView = true
                }) {
                    Text("Calculate Insulin ")
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
                    mealName: viewModel.mealName.isEmpty ? meal.title : viewModel.mealName, // استخدم اسم الوجبة من ViewModel إذا كان موجوداً
                    mealType: meal.title // يمرر "Lunch", "Breakfast", etc.
                )
            }
        }
    }
}

#Preview {
    EditMealView(
        meal: MealItem(
            title: "Lunch",
            imageName: "lunch",
            color: .yellow.opacity(0.3)
        )
    )
}

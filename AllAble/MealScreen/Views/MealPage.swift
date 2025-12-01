//
//  MealPage.swift
//  AllAble
//
//  Created by lamess on 10/06/1447 AH.
//

//import SwiftUI
//
//struct MealContentView: View {
//    
//    //@StateObject private var viewModel = MealContentViewModel()
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 20) {
//            
//            Text("إضافة محتوى الوجبة")
//                .font(.title3.bold())
//            
//            // Name
//            TextField("اسم الوجبة", text: $viewModel.mealName)
//                .textFieldStyle(.roundedBorder)
//            
//            // Carbs
//            TextField("قيمة الكارب (g)", text: $viewModel.carbValue)
//                .keyboardType(.numberPad)
//                .textFieldStyle(.roundedBorder)
//            
//            Button {
//                viewModel.addItem()
//            } label: {
//                HStack {
//                    Image(systemName: "plus.circle.fill")
//                    Text("إضافة عنصر")
//                }
//                .foregroundColor(.black)
//                .padding()
//                .frame(maxWidth: .infinity)
//                .background(Color.yellow.opacity(0.4))
//                .cornerRadius(12)
//            }
//            
//            // List of added items
////            ForEach(viewModel.items) { item in
////                HStack {
////                    Text("\(item.name) — \(item.carbs)g")
////                    Spacer()
////                    Button {
////                        //viewModel.removeItem(item.id)
////                    } label: {
////                        Image(systemName: "xmark.circle")
////                            .foregroundColor(.red)
////                    }
////                }
////                .padding()
////                .background(Color.white)
////                .cornerRadius(12)
////            }
//            
//            // Total
////            Text("إجمالي الكارب: \(viewModel.totalCarbs) g")
////                .font(.headline)
////                .padding(.top)
////            
//            Spacer()
//            
//            Button("احسب الوجبة") {
//                print("Navigate to calculation result")
//            }
//            .frame(maxWidth: .infinity)
//            .padding()
//            .font(.title3.bold())
//            .background(Color.yellow.opacity(0.6))
//            .cornerRadius(14)
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    MealContentView()
//}

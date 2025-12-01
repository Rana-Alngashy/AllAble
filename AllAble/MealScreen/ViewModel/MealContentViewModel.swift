//
//  MealContentViewModel.swift
//  AllAble
//
//  Created by lamess on 10/06/1447 AH.
//
//import SwiftUI
//import Combine
//class MealContentViewModel: ObservableObject {
//    @Published var mealName: String = ""
//    @Published var carbValue: String = ""
//    
//        // @Published var items: [MealItem] = []
//    
//    var totalCarbs: Int {
//        items.reduce(0) { $0 + $1.carbs }
//    }
//    
//    func addItem() {
//        guard let carbInt = Int(carbValue), !mealName.isEmpty else { return }
//        
//        let newItem = MealItem(name: mealName, carbs: carbInt)
//        items.append(newItem)
//        
//        mealName = ""
//        carbValue = ""
//    }
//    
////    func removeItem(_ id: UUID) {
////        items.removeAll { $0.id == id }
////    }
//}

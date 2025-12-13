//
//  MealContentViewModel.swift
//  AllAble
//
//  Created by lamess on 10/06/1447 AH.
//
//


import SwiftUI
import Combine

class MealContentViewModel: ObservableObject {

    @Published var mealName: String = ""
    @Published var mealCarbs: String = ""
    
    @Published var subItems: [MealSubItem] = []

    // إضافة صنف جديد
    func addSubItem() {
        subItems.append(MealSubItem(name: "", carbs: ""))
    }

    // مجموع الكارب الكلي
    var totalCarbs: Int {
        let main = Int(mealCarbs) ?? 0
        let subs = subItems.map { Int($0.carbs) ?? 0 }.reduce(0, +)
        return main + subs
    }
}

struct MealSubItem: Identifiable {
    let id = UUID()
    var name: String
    var carbs: String
}






















//import SwiftUI
//import Combine
//
//class MealContentViewModel: ObservableObject {
//
//    @Published var mealName: String = ""
//    @Published var mealCarbs: String = ""
//
//    @Published var subItems: [MealSubItem] = []
//
//    // إضافة صنف جديد
//    func addSubItem() {
//        subItems.append(MealSubItem(name: "", carbs: ""))
//    }
//
//    // مجموع الكارب الكلي
//    var totalCarbs: Int {
//        let main = Int(mealCarbs) ?? 0
//        let subs = subItems.map { Int($0.carbs) ?? 0 }.reduce(0, +)
//        return main + subs
//    }
//}
//
//struct MealSubItem: Identifiable {
//    let id = UUID()
//    var name: String
//    var carbs: String
//}

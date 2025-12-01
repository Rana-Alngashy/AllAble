//
//  AddMealViewModel.swift
//  AllAble
//
//  Created by lamess on 10/06/1447 AH.
//
import SwiftUI
import Combine

class AddMealViewModel: ObservableObject {
    
    @Published var meals: [MealItem] = [
        MealItem(title: "Breakfast",
                 imageName: "breakfastImg",
                 color: Color(#colorLiteral(red: 1, green: 0.98, blue: 0.80, alpha: 1))), // أصفر فاتح
        
        MealItem(title: "Lunch",
                 imageName: "lunchImg",
                 color: Color(#colorLiteral(red: 0.85, green: 1.00, blue: 0.85, alpha: 1))), // أخضر فاتح
        
        MealItem(title: "Dinner",
                 imageName: "dinnerImg",
                 color: Color(#colorLiteral(red: 0.85, green: 0.95, blue: 1.00, alpha: 1))), // أزرق فاتح
        
        MealItem(title: "Snacks",
                 imageName: "snacksImg",
                 color: Color(#colorLiteral(red: 1.00, green: 0.90, blue: 0.95, alpha: 1))) // وردي فاتح
    ]
}

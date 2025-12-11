//
//  HistoryStore.swift
//  AllAble
//
//  Created by Wteen Alghamdy on 16/06/1447 AH.
//

import SwiftUI
import Combine

// 1. The Data Model
struct HistoryEntry: Identifiable {
    let id = UUID()
    let mealTypeTitle: String
    let mealName: String
    let mainMealCarbs: Double          // ← كارب الوجبة الرئيسية
    let subItems: [MealSubItem]        // ← العناصر الفرعية مع كارب كل واحد
    let totalCarbs: Double
    let insulinDose: Double
    let date: Date = Date()            // ← التاريخ الافتراضي (وقت الحفظ)
}

// 2. The Store Class
class HistoryStore: ObservableObject {
    @Published var entries: [HistoryEntry] = []
    
    func addEntry(_ entry: HistoryEntry) {
        entries.append(entry)
    }
}

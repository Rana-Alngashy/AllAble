//
//  HistoryViewModel.swift
//  AllAble
//
//  Created by lamess on 18/06/1447 AH.
//

import SwiftUI
import Combine

class HistoryViewModel: ObservableObject {
    
    // البيانات الظاهرة بالفيو
    @Published var entries: [HistoryEntry] = []
    
    // الربط مع الـ Store (مصدر البيانات)
    private var store: HistoryStore
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - Init
    init(store: HistoryStore) {
        self.store = store
        
        // ربط تلقائي بين Store → ViewModel
        store.$entries
            .receive(on: RunLoop.main)
            .assign(to: &$entries)
    }
    
    
    // MARK: - Functions to manage meals
    func addMeal(type: String, name: String, carbs: Double, dose: Double) {
        let newEntry = HistoryEntry(
            mealTypeTitle: type,
            mealName: name,
            totalCarbs: carbs,
            insulinDose: dose
        )
        
        store.addEntry(newEntry)
    }
    
    
    // مثال: فلترة حسب النوع (اختياري)
    func meals(of type: String) -> [HistoryEntry] {
        entries.filter { $0.mealTypeTitle.lowercased() == type.lowercased() }
    }
}

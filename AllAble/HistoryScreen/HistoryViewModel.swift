//
//  HistoryViewModel.swift
//  AllAble
//
//  Created by Wteen Alghamdy on 16/06/1447 AH.
//

import SwiftUI
import Combine

class HistoryViewModel: ObservableObject {
    @Published var items: [HistoryModel] = []
    
    func load(from store: HistoryStore) {
        // يتم تحويل HistoryEntry إلى HistoryModel هنا
        self.items = store.entries.map {
            HistoryModel(
                mealTypeTitle: $0.mealTypeTitle,
                mealName: $0.mealName,
                totalCarbs: $0.totalCarbs, // الآن كـ Double
                insulinDose: $0.insulinDose
            )
        }
    }
}

import SwiftUI
import Combine

class HistoryViewModel: ObservableObject {
    @Published var items: [HistoryModel] = []
    
    func load(from store: HistoryStore) {
        self.items = store.entries.map {
            HistoryModel(
                mealTypeTitle: $0.mealTypeTitle,
                mealName: $0.mealName,
                totalCarbs: Double($0.totalCarbs), // تحويل Int إلى Double
                insulinDose: $0.insulinDose
            )
        }
    }
}


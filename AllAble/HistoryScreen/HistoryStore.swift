import SwiftUI

// The data model expected by the Store (Carbs as Int, based on your ViewModel logic)
struct HistoryEntry: Identifiable {
    let id = UUID()
    let mealTypeTitle: String
    let mealName: String
    let totalCarbs: Int
    let insulinDose: Double
}

class HistoryStore: ObservableObject {
    @Published var entries: [HistoryEntry] = []
    
    // Optional: Add test data to verify the list works
    init() {
        entries = [
            HistoryEntry(mealTypeTitle: "Lunch", mealName: "Pasta", totalCarbs: 45, insulinDose: 3.0),
            HistoryEntry(mealTypeTitle: "Breakfast", mealName: "Oats", totalCarbs: 30, insulinDose: 2.0)
        ]
    }
    
    func addEntry(_ entry: HistoryEntry) {
        entries.append(entry)
    }
}

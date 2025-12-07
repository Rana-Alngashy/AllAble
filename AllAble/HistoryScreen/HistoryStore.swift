import SwiftUI
import Combine  // <--- This is the specific missing import causing your error

// 1. The Data Model
struct HistoryEntry: Identifiable {
    let id = UUID()
    let mealTypeTitle: String
    let mealName: String
    let totalCarbs: Double // Changed to Double to match your other files
    let insulinDose: Double
}

// 2. The Store Class
class HistoryStore: ObservableObject {
    @Published var entries: [HistoryEntry] = []
    
    // Initializer with some test data so you can see if it works immediately
   // init() {
      //  entries = [
       //     HistoryEntry(mealTypeTitle: "Lunch", mealName: "Pasta", totalCarbs: 45.0, insulinDose: 3.0),
       //     HistoryEntry(mealTypeTitle: "Breakfast", mealName: "Oats", totalCarbs: 30.0, insulinDose: 2.0)
      //  ]
   // }
    
    func addEntry(_ entry: HistoryEntry) {
        entries.append(entry)
    }
}

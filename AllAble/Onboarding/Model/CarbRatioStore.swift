//
//  CarbRatioStore.swift
//  AllAble
//
//  Created by Wteen Alghamdy on 18/06/1447 AH.
////
//  CarbRatioStore.swift
//  AllAble
//
//  Created by Wteen Alghamdy on 18/06/1447 AH.
//
// CarbRatioStore.swift

import Foundation
import Combine
import SwiftUI

/// هيكل بيانات لنسبة الكارب إلى الأنسولين
struct CarbRatioEntry: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var name: String
    var ratio: Double

    init(id: UUID = UUID(), name: String, ratio: Double) {
        self.id = id
        self.name = name
        self.ratio = ratio
    }
    
    // تعريف النسبة الافتراضية مرة واحدة (كنموذج أولي)
    static func defaultPrototype() -> CarbRatioEntry {
        return CarbRatioEntry(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
            name: NSLocalizedString("FallbackRatio", comment: "Default Ratio"),
            ratio: 15.0
        )
    }
}

/// مدير لجميع نسب الكارب مع حفظها في UserDefaults
final class CarbRatioStore: ObservableObject {
    @Published var ratios: [CarbRatioEntry] = []
    
    @Published var defaultRatio: CarbRatioEntry = CarbRatioEntry.defaultPrototype()
    
    // ✅ FIX: خاصية محتسبة لتجميع النسبة الافتراضية والنسب المخصصة للـ Picker
    var allRatios: [CarbRatioEntry] {
        var combined = [defaultRatio]
        combined.append(contentsOf: ratios)
        return combined
    }
    
    private let storageKey = "storedCarbRatioEntries"
    private let defaultRatioStorageKey = "storedDefaultCarbRatio"
    
    init() {
        loadDefaultRatio()
        loadCustomRatios()
    }

    // MARK: - Persistence

    private func loadDefaultRatio() {
        if let savedData = UserDefaults.standard.data(forKey: defaultRatioStorageKey),
           let decodedDefault = try? JSONDecoder().decode(CarbRatioEntry.self, from: savedData) {
            
            self.defaultRatio = CarbRatioEntry(
                id: CarbRatioEntry.defaultPrototype().id,
                name: decodedDefault.name,
                ratio: decodedDefault.ratio
            )
            
        } else {
            self.defaultRatio = CarbRatioEntry.defaultPrototype()
        }
    }

    private func saveDefaultRatio() {
        if let encoded = try? JSONEncoder().encode(defaultRatio) {
            UserDefaults.standard.set(encoded, forKey: defaultRatioStorageKey)
        }
    }

    private func loadCustomRatios() {
        if let savedData = UserDefaults.standard.data(forKey: storageKey),
           let decodedRatios = try? JSONDecoder().decode([CarbRatioEntry].self, from: savedData) {
            
            ratios = decodedRatios.filter { $0.id != defaultRatio.id }
            
        } else {
            ratios = []
        }
    }

    private func saveCustomRatios() {
        if let encoded = try? JSONEncoder().encode(ratios) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    // MARK: - CRUD Operations

    func addRatio(name: String, ratio: Double) {
        let newEntry = CarbRatioEntry(name: name, ratio: ratio)
        ratios.insert(newEntry, at: 0)
        saveCustomRatios()
        objectWillChange.send()
    }
    
    func updateRatio(_ entry: CarbRatioEntry) {
        if entry.id == defaultRatio.id {
            self.defaultRatio.ratio = entry.ratio
            saveDefaultRatio()
            objectWillChange.send()
            
        } else if let index = ratios.firstIndex(where: { $0.id == entry.id }) {
            ratios[index] = entry
            saveCustomRatios()
            objectWillChange.send()
        }
    }
    
    func deleteRatio(_ entry: CarbRatioEntry) {
        guard entry.id != defaultRatio.id else { return }
        ratios.removeAll { $0.id == entry.id }
        saveCustomRatios()
        objectWillChange.send()
    }
}

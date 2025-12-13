//////
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
import Foundation
import Combine
import SwiftUI

/// هيكل بيانات لنسبة الكارب إلى الأنسولين
// ✅ تمت إضافة Hashable لحل مشكلة الـ Picker في EditMealView
struct CarbRatioEntry: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var name: String
    var ratio: Double

    init(id: UUID = UUID(), name: String, ratio: Double) {
        self.id = id
        self.name = name
        self.ratio = ratio
    }
}

/// مدير لجميع نسب الكارب مع حفظها في UserDefaults
final class CarbRatioStore: ObservableObject {
    @Published var ratios: [CarbRatioEntry] = []
    
    private let storageKey = "storedCarbRatioEntries"
    
    // النسبة الافتراضية الثابتة (FallBack)
    var defaultRatio: CarbRatioEntry {
        return CarbRatioEntry(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
            name: NSLocalizedString("FallbackRatio", comment: ""),
            ratio: 15.0
        )
    }

    init() {
        loadRatios()
        
        // التأكد من أن النسبة الافتراضية موجودة في بداية القائمة
        if !ratios.contains(where: { $0.id == defaultRatio.id }) {
            ratios.insert(defaultRatio, at: 0)
        }
    }

    // MARK: - Persistence (الحفظ والتحميل)

    private func loadRatios() {
        if let savedData = UserDefaults.standard.data(forKey: storageKey),
           let decodedRatios = try? JSONDecoder().decode([CarbRatioEntry].self, from: savedData) {
            
            // نحمل النسب المخصصة فقط (مع استثناء الافتراضية التي يتم إضافتها يدوياً)
            ratios = decodedRatios.filter { $0.id != defaultRatio.id }
            
        } else {
            ratios = []
        }
        
        // نضيف النسبة الافتراضية في بداية القائمة دائماً
        ratios.insert(defaultRatio, at: 0)
    }

    private func saveRatios() {
        // نحفظ النسب المخصصة فقط (نستثني النسبة الافتراضية)
        let ratiosToSave = ratios.filter { $0.id != defaultRatio.id }
        
        if let encoded = try? JSONEncoder().encode(ratiosToSave) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
            objectWillChange.send()
        }
    }
    
    // MARK: - CRUD Operations

    func addRatio(name: String, ratio: Double) {
        let newEntry = CarbRatioEntry(name: name, ratio: ratio)
        // نضيفها بعد النسبة الافتراضية
        ratios.insert(newEntry, at: 1)
        saveRatios()
    }
    
    func updateRatio(_ entry: CarbRatioEntry) {
        if entry.id == defaultRatio.id {
            // تحديث النسبة الافتراضية (لا تحفظ في UserDefaults)
            if let index = ratios.firstIndex(where: { $0.id == entry.id }) {
                ratios[index].ratio = entry.ratio
                objectWillChange.send()
            }
        } else if let index = ratios.firstIndex(where: { $0.id == entry.id }) {
            // تحديث النسبة المخصصة (وحفظها في UserDefaults)
            ratios[index] = entry
            saveRatios()
        }
    }
    
    // ✅ دالة الحذف باستخدام CarbRatioEntry (تستخدم في CarbRatioPage)
    func deleteRatio(_ entry: CarbRatioEntry) {
        // منع حذف النسبة الافتراضية
        guard entry.id != defaultRatio.id else { return }
        ratios.removeAll { $0.id == entry.id }
        saveRatios()
    }
}

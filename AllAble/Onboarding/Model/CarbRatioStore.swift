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
            name: NSLocalizedString("FallbackRatio", comment: ""),
            ratio: 15.0
        )
    }
}

/// مدير لجميع نسب الكارب مع حفظها في UserDefaults
final class CarbRatioStore: ObservableObject {
    @Published var ratios: [CarbRatioEntry] = []
    
    // ✅ FIX: النسبة الافتراضية أصبحت خاصية مخزنة و @Published لتكون قابلة للتعديل
    @Published var defaultRatio: CarbRatioEntry = CarbRatioEntry.defaultPrototype()
    
    private let storageKey = "storedCarbRatioEntries"
    private let defaultRatioStorageKey = "storedDefaultCarbRatio" // ✅ مفتاح جديد لحفظ القيمة الافتراضية
    
    init() {
        loadDefaultRatio() // ✅ حمل القيمة الافتراضية أولاً
        loadCustomRatios() // ✅ حمل النسب المخصصة
    }

    // MARK: - Persistence (الحفظ والتحميل)

    private func loadDefaultRatio() {
        // محاولة تحميل النسبة الافتراضية المحفوظة
        if let savedData = UserDefaults.standard.data(forKey: defaultRatioStorageKey),
           let decodedDefault = try? JSONDecoder().decode(CarbRatioEntry.self, from: savedData) {
            
            self.defaultRatio = decodedDefault
            
        } else {
            // إذا لم يتم العثور على قيمة محفوظة، استخدم النموذج الأولي الافتراضي
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
            
            // نحمل النسب المخصصة فقط
            ratios = decodedRatios.filter { $0.id != defaultRatio.id }
            
        } else {
            ratios = []
        }
    }

    private func saveCustomRatios() {
        // نحفظ النسب المخصصة فقط
        if let encoded = try? JSONEncoder().encode(ratios) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    // MARK: - CRUD Operations

    func addRatio(name: String, ratio: Double) {
        let newEntry = CarbRatioEntry(name: name, ratio: ratio)
        ratios.insert(newEntry, at: 0) // نضيفها في البداية (قبل الافتراضية منطقياً في القائمة المرئية)
        saveCustomRatios()
        objectWillChange.send() // لتحديث القائمة المرئية
    }
    
    // ✅ FIX: تحديث Ratio الآن يتعامل مع النسبة الافتراضية بشكل صحيح
    func updateRatio(_ entry: CarbRatioEntry) {
        if entry.id == defaultRatio.id {
            // تحديث النسبة الافتراضية
            self.defaultRatio.ratio = entry.ratio
            saveDefaultRatio() // ✅ حفظ القيمة الجديدة الافتراضية
            objectWillChange.send() // إرسال التغيير لتحديث الواجهة
            
        } else if let index = ratios.firstIndex(where: { $0.id == entry.id }) {
            // تحديث النسبة المخصصة
            ratios[index] = entry
            saveCustomRatios()
            objectWillChange.send()
        }
    }
    
    // دالة الحذف
    func deleteRatio(_ entry: CarbRatioEntry) {
        guard entry.id != defaultRatio.id else { return }
        ratios.removeAll { $0.id == entry.id }
        saveCustomRatios()
        objectWillChange.send()
    }
}

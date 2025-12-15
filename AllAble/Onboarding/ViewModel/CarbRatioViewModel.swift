//
//  CarbRatioViewModel.swift
//  AllAble
//
//  Created by Wteen Alghamdy on 21/06/1447 AH.
//
// CarbRatioViewModel.swift


import Foundation
import Combine
import SwiftUI

final class CarbRatioViewModel: ObservableObject {
    
    @Published var newRatioName: String = ""
    @Published var newRatioValue: String = ""
    @Published var isAddButtonEnabled: Bool = false
    
    private var store: CarbRatioStore
    private var cancellables = Set<AnyCancellable>()
    
    init(store: CarbRatioStore) {
        self.store = store
        
        Publishers.CombineLatest($newRatioName, $newRatioValue)
            .map { name, value in
                let nameIsValid = !name.trimmingCharacters(in: .whitespaces).isEmpty
                let valueIsValid = (Double(value) ?? 0) > 0
                return nameIsValid && valueIsValid
            }
            .assign(to: &$isAddButtonEnabled)
    }
    
    func addRatio() {
        guard isAddButtonEnabled, let ratio = Double(newRatioValue) else { return }
        
        guard ratio > 0 else { return }
        
        store.addRatio(name: newRatioName, ratio: ratio)
        
        newRatioName = ""
        newRatioValue = ""
    }
    
    func deleteRatio(entry: CarbRatioEntry) {
        store.deleteRatio(entry)
    }
    
    func updateDefaultRatioValue(newValue: Double?) {
        guard let newValue = newValue, newValue > 0 else {
                    return
                }
        // ✅ هذا الجزء صحيح الآن بعد تعديل الـ Store
        var updatedEntry = store.defaultRatio
        updatedEntry.ratio = newValue
        store.updateRatio(updatedEntry)
    }
}

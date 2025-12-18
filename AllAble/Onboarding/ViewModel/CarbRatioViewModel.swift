//
//  CarbRatioViewModel.swift
//  AllAble
//
//  Created by Wteen Alghamdy on 21/06/1447 AH.
//
// CarbRatioViewModel.swift
import Foundation
import Combine

final class CarbRatioViewModel: ObservableObject {
    
    @Published var newRatioName: String = ""
    @Published var newRatioValue: String = ""
    @Published var isAddButtonEnabled: Bool = false
    
    private let store: CarbRatioStore
    private var cancellables = Set<AnyCancellable>()
    
    init(store: CarbRatioStore) {
        self.store = store
        
        Publishers.CombineLatest($newRatioName, $newRatioValue)
            .map { name, value in
                !name.trimmingCharacters(in: .whitespaces).isEmpty &&
                (Double(value) ?? 0) > 0
            }
            .assign(to: &$isAddButtonEnabled)
    }
    
    func addRatio() {
        guard let ratio = Double(newRatioValue), ratio > 0 else { return }
        store.addRatio(name: newRatioName, ratio: ratio)
        newRatioName = ""
        newRatioValue = ""
    }
    
    func deleteRatio(entry: CarbRatioEntry) {
        store.deleteRatio(entry)
    }
    
    // ✅ FIXED: allows smooth editing & deletion
    func updateDefaultRatioValue(newValue: Double?) {
        guard let newValue else { return }
        guard newValue > 0 else { return }
        
        var updated = store.defaultRatio
        updated.ratio = newValue
        store.updateRatio(updated)
    }
}

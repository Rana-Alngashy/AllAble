////
//  Untitled.swift
//  AllAble
//
//  Created by NORAH on 11/06/1447 AH.
//

import Foundation
import Combine

class AccountViewModel: ObservableObject {
    
    // يعتمد على AccountModel المعرّف في ملف account_model.swift
    @Published var accountData = AccountModel(
        name: "",
        age: ""
    )
    
    init() {
        // يمكن وضع أي منطق تهيئة هنا (مثل جلب البيانات الأولية)
    }
    
    func saveChanges() {
        print("Data saved from ViewModel: \(accountData)")
    }
}

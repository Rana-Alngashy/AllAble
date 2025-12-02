//
//  Untitled.swift
//  AllAble
//
//  Created by NORAH on 11/06/1447 AH.
//

import Foundation
import Combine

class AccountViewModel: ObservableObject {
    
    // `@Published` تستبدل وظيفة `@State` وتجعل البيانات قابلة للمراقبة من الـ View
    @Published var accountData = AccountModel(
        name: "",
        age: "",
        guardianNumber: "",
        carbonValue: ""
    )
    
    init() {
        // يمكن وضع أي منطق تهيئة هنا (مثل جلب البيانات الأولية)
    }
    
    // يمكن إضافة دالة حفظ هنا إذا أردت استدعاءها لاحقاً دون زر:
    /*
    func saveChanges() {
        print("Data saved from ViewModel: \(accountData)")
    }
    */
}

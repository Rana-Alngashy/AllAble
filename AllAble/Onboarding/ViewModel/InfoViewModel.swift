//
//
//import Foundation
//import Combine
//
//final class InfoViewModel: ObservableObject {
//    
//    @Published var name: String = ""
//    @Published var age: String = ""
//    @Published var carbValue: String = ""   // قيمة الكارب
//    
//    @Published var isNextButtonEnabled: Bool = false
//    @Published var shouldNavigateToVerification = false
//    @Published var isCarbExplanationVisible = false
//    
//    private var cancellables = Set<AnyCancellable>()
//    
//    init() {
//        Publishers.CombineLatest3($name, $age, $carbValue)
//            .map { name, age, carbValue in
//                let nameIsValid = !name.trimmingCharacters(in: .whitespaces).isEmpty
//                let ageIsValid = (Int(age) ?? 0) > 0
//                let carbValueIsValid = (Int(carbValue) ?? 0) > 0
//                return nameIsValid && ageIsValid && carbValueIsValid
//            }
//            .assign(to: \.isNextButtonEnabled, on: self)
//            .store(in: &cancellables)
//    }
//    
//    // 🔥 حفظ البيانات قبل الانتقال
//    func handleNext() {
//        guard isNextButtonEnabled else { return }
//        storedCarbValue = carbValue    // ← ★★ أهم سطر ★★
//
//        // ✨ حفظ البيانات بنفس المفاتيح المستخدمة في AccountPage
//        UserDefaults.standard.set(name, forKey: "account.name")
//        UserDefaults.standard.set(age, forKey: "account.age")
//        UserDefaults.standard.set(carbValue, forKey: "account.carbValue")
//        
//        
//        // التنقل للصفحة التالية
//        shouldNavigateToVerification = true
//    }
//    
//    func toggleCarbExplanation() {
//        isCarbExplanationVisible.toggle()
//    }
//}
//

import Foundation
import Combine
import SwiftUI

final class InfoViewModel: ObservableObject {
    
    // 🔥 قيم يتم حفظها في الواجهة فقط
    @Published var name: String = ""
    @Published var age: String = ""
    @Published var carbValue: String = ""
    
    // 🔥 AppStorage للحفظ الفعلي
    @AppStorage("Account.Name") private var storedName: String = ""
    @AppStorage("Account.Age") private var storedAge: String = ""
    @AppStorage("Account.CarbValue") private var storedCarbValue: String = ""


    @Published var isNextButtonEnabled: Bool = false
    @Published var shouldNavigateToVerification = false
    @Published var isCarbExplanationVisible = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        name = storedName
        age = storedAge
        carbValue = storedCarbValue

        // التحقق من صحة المدخلات
        Publishers.CombineLatest3($name, $age, $carbValue)
            .map { name, age, carbValue in
                let nameIsValid = !name.trimmingCharacters(in: .whitespaces).isEmpty
                let ageIsValid = (Int(age) ?? 0) > 0
                let carbValueIsValid = (Int(carbValue) ?? 0) > 0
                return nameIsValid && ageIsValid && carbValueIsValid
            }
            .assign(to: \.isNextButtonEnabled, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: - حفظ قبل الانتقال
    func handleNext() {
        guard isNextButtonEnabled else { return }

        // ———— حفظ القيم في AppStorage ————
        storedName = name
        storedAge = age
        storedCarbValue = carbValue

        // ———— الانتقال ————
        shouldNavigateToVerification = true
    }
    
    func toggleCarbExplanation() {
        isCarbExplanationVisible.toggle()
    }
}

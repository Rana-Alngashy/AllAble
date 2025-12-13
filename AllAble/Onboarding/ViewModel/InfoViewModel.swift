//
//
//






import Foundation
import Combine
import SwiftUI

final class InfoViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var age: String = ""
    
    // 💾 App Storage للحفظ الفعلي
    @AppStorage("Account.Name") private var storedName: String = ""
    @AppStorage("Account.Age") private var storedAge: String = ""

    @Published var isNextButtonEnabled: Bool = false
    // ✅ تغيير اسم متغير الملاحة ليعكس الصفحة الجديدة
    @Published var shouldNavigateToCarbRatio = false
    @Published var isCarbExplanationVisible = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        name = storedName
        age = storedAge
        
        // التحقق من صحة المدخلات (الاسم والعمر فقط)
        Publishers.CombineLatest($name, $age)
            .map { name, age in
                let nameIsValid = !name.trimmingCharacters(in: .whitespaces).isEmpty
                let ageIsValid = (Int(age) ?? 0) > 0
                return nameIsValid && ageIsValid
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

        // ———— الانتقال إلى CarbRatioPage ————
        shouldNavigateToCarbRatio = true
    }
    
    func toggleCarbExplanation() {
        isCarbExplanationVisible.toggle()
    }
}

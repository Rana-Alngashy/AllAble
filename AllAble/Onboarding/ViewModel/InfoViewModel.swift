//
//  InfoViewModel.swift
//  AllAble
//
//  Created by Wteen Alghamdy on 15/06/1447 AH.
//

//import Foundation
//import Combine
//
//final class InfoViewModel: ObservableObject {
//    @Published var name: String = ""
//    @Published var age: String = ""
//    @Published var carbValue: String = ""
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
//    func handleNext() {
//        guard isNextButtonEnabled else { return }
//        shouldNavigateToVerification = true
//    }
//    
//    func toggleCarbExplanation() {
//        isCarbExplanationVisible.toggle()
//    }
//}










//import Foundation
//import Combine
//
//final class InfoViewModel: ObservableObject {
//    @Published var name: String = ""
//    @Published var age: String = ""
//    @Published var carbValue: String = "" // قيمة الكارب
//    
//    @Published var isNextButtonEnabled: Bool = false
//    @Published var shouldNavigateToVerification = false
//    @Published var isCarbExplanationVisible = false
//    
//    private var cancellables = Set<AnyCancellable>()
//    
//    init() {
//        // التحقق من أن جميع الحقول الرئيسية صالحة
//        Publishers.CombineLatest3($name, $age, $carbValue)
//            .map { name, age, carbValue in
//                let nameIsValid = !name.trimmingCharacters(in: .whitespaces).isEmpty
//                // التحقق من أن العمر وقيمة الكارب رقمية وأكبر من صفر
//                let ageIsValid = (Int(age) ?? 0) > 0
//                let carbValueIsValid = (Int(carbValue) ?? 0) > 0
//                return nameIsValid && ageIsValid && carbValueIsValid
//            }
//            .assign(to: \.isNextButtonEnabled, on: self)
//            .store(in: &cancellables)
//    }
//    
//    func handleNext() {
//        guard isNextButtonEnabled else { return }
//        shouldNavigateToVerification = true
//    }
//    
//    func toggleCarbExplanation() {
//        isCarbExplanationVisible.toggle()
//    }
//}








import Foundation
import Combine

final class InfoViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var age: String = ""
    @Published var carbValue: String = "" // قيمة الكارب
    
    @Published var isNextButtonEnabled: Bool = false
    @Published var shouldNavigateToVerification = false
    @Published var isCarbExplanationVisible = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
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
    
    func handleNext() {
        guard isNextButtonEnabled else { return }
        shouldNavigateToVerification = true
    }
    
    func toggleCarbExplanation() {
        isCarbExplanationVisible.toggle()
    }
}

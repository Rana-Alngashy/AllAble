//
//  VerificationViewModel.swift
//  AllAble
//
//  Created by Wteen Alghamdy on 15/06/1447 AH.
//



//
//import Foundation
//import Combine
//import SwiftUI
//
//
//final class VerificationViewModel: ObservableObject {
//    enum VerificationState {
//        case enterEmail
//        case enterCode
//    }
//    
//    @Published var state: VerificationState = .enterEmail
//    @Published var parentEmail: String = ""
//    @Published var verificationCode: [String] = Array(repeating: "", count: 4)
//    
//    // 🔑 المتغير الذي يرسل إشارة لـ VerificationView للإغلاق
//    @Published var shouldEndOnboarding = false
//    
//    // 💾 AppStorage لحفظ البيانات الرئيسية (للاستمرارية)
//    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
//    @AppStorage("account.name") private var storedName: String = ""
//    @AppStorage("account.carbonValue") private var storedCarbValue: String = "15" // لحفظ قيمة الكارب
//    @AppStorage("selectedAvatarImageName") private var selectedAvatarImageName: String = "AvatarGirl" // لحفظ الأفاتار
//
//    var codeString: String {
//        return verificationCode.joined()
//    }
//
//    var isSendCodeButtonEnabled: Bool {
//        return parentEmail.contains("@") && parentEmail.count > 5
//    }
//
//    var isVerifyButtonEnabled: Bool {
//        return codeString.count == 4 && state == .enterCode
//    }
//
//    func sendVerificationCode() {
//        if isSendCodeButtonEnabled {
//            state = .enterCode
//        }
//    }
//    
//    // 🎯 الوظيفة المسؤولة عن الحفظ والتحويل لصفحة الهوم
//    func verifyCode(userData: UserDataForVerification) {
//        guard isVerifyButtonEnabled else { return }
//        
//        // 1. حفظ البيانات المجمعة في AppStorage (CRITICAL FIX)
//        storedName = userData.name
//        storedCarbValue = userData.carbValue
//        selectedAvatarImageName = userData.selectedAvatar.imageName
//        
//        // 2. تعيين علامة الإكمال العامة (مفتاح التحويل في AllAbleApp)
//        hasCompletedOnboarding = true
//
//        // 3. إطلاق إشارة الإغلاق للـ VerificationView
//        DispatchQueue.main.async {
//            self.shouldEndOnboarding = true
//        }
//    }
//}











//
//  VerificationViewModel.swift
//  AllAble
//
//  Created by Wteen Alghamdy on 15/06/1447 AH.
//

import Foundation
import Combine
import SwiftUI // 🔥 CRITICAL FIX: required for @AppStorage

enum VerificationState {
    case enterEmail
    case enterCode
}

final class VerificationViewModel: ObservableObject {
    
    @Published var state: VerificationState = .enterEmail
    @Published var parentEmail: String = ""
    @Published var verificationCode: [String] = Array(repeating: "", count: 4)
    
    // 🔑 متغير الإشارة لإغلاق شاشة التحقق (يُستخدم في VerificationView)
    @Published var shouldEndOnboarding = false
    
    // 💾 AppStorage لحفظ البيانات الرئيسية (للاستمرارية)
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @AppStorage("account.name") private var storedName: String = ""
    @AppStorage("account.age") private var storedAge: String = ""
    @AppStorage("account.carbonValue") private var storedCarbValue: String = "15"
    @AppStorage("selectedAvatarImageName") private var selectedAvatarImageName: String = "AvatarGirl"

    var codeString: String {
        return verificationCode.joined()
    }

    var isSendCodeButtonEnabled: Bool {
        return parentEmail.contains("@") && parentEmail.count > 5
    }

    var isVerifyButtonEnabled: Bool {
        return codeString.count == 4 && state == .enterCode
    }

    func sendVerificationCode() {
        if isSendCodeButtonEnabled {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.state = .enterCode
            }
        }
    }
    
    // 🎯 الوظيفة المسؤولة عن الحفظ والتحويل لصفحة الهوم
    func verifyCode(userData: UserDataForVerification) {
        guard isVerifyButtonEnabled else { return }
        
        // 1. حفظ البيانات المجمعة في AppStorage
        self.storedName = userData.name
        self.storedAge = userData.age
        self.storedCarbValue = userData.carbValue
        self.selectedAvatarImageName = userData.selectedAvatar.imageName
        
        // 2. تعيين علامة الإكمال العامة (مفتاح التحويل في AllAbleApp)
        self.hasCompletedOnboarding = true

        // 3. إطلاق إشارة الإغلاق للـ VerificationView
        DispatchQueue.main.async {
            self.shouldEndOnboarding = true
        }
    }
}

//
//  UserDataForVerification.swift
//  AllAble
//
//  Created by Wteen Alghamdy on 15/06/1447 AH.
//




//
//import Foundation
//import Combine
//import SwiftUI // مطلوب لـ @AppStorage
//
//// FIX: هيكل مؤقت لبيانات المستخدم يتم تمريره بين الـ Views
//struct UserDataForVerification {
//    let name: String
//    let carbValue: String
//    let selectedAvatar: Avatar
//}
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
//    @Published var shouldNavigateToCongrats = false // FIX: لإدارة الانتقال لـ CongratsView
//    
//    // FIX: AppStorage لتخزين البيانات النهائية
//    @AppStorage("account.name") private var storedName: String = ""
//    @AppStorage("account.age") private var storedAge: String = "" // نحتاج تخزين العمر أيضاً
//    @AppStorage("account.carbonValue") private var storedCarbValue: String = "15" // CRITICAL FIX
//    @AppStorage("selectedAvatarImageName") private var selectedAvatarImageName: String = "AvatarGirl"
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
//    // FIX: وظيفة التحقق النهائية مع حفظ البيانات
//    func verifyCode(userData: UserDataForVerification) {
//        guard isVerifyButtonEnabled else { return }
//        
//        // 1. حفظ البيانات المجمعة في AppStorage (نفس المفاتيح المستخدمة في AccountPage)
//        storedName = userData.name
//        storedCarbValue = userData.carbValue // تم حفظ قيمة الكارب هنا
//        selectedAvatarImageName = userData.selectedAvatar.imageName
//        // NOTE: نحتاج لـ age أيضاً، سأفترض أن InfoView يمرر العمر string.
//        
//        // 2. إشارة للانتقال إلى CongratsView
//        DispatchQueue.main.async {
//            self.shouldNavigateToCongrats = true
//        }
//    }
//}








//
//import Foundation
//import Combine
//import SwiftUI
//
//// NOTE: هذا الهيكل يستخدم لتمرير البيانات من InfoView إلى VerificationView
//struct UserDataForVerification {
//    let name: String
//    let carbValue: String
//    let selectedAvatar: Avatar
//}
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
//    @Published var shouldNavigateToCongrats = false
//    
//    // FIX: AppStorage لتخزين البيانات النهائية التي سيتم استخدامها في MainPage و CalculateView
//    @AppStorage("account.name") private var storedName: String = ""
//    @AppStorage("account.carbonValue") private var storedCarbValue: String = "15" // CRITICAL FIX
//    @AppStorage("selectedAvatarImageName") private var selectedAvatarImageName: String = "AvatarGirl"
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
//    // FIX: وظيفة التحقق وحفظ البيانات
//    func verifyCode(userData: UserDataForVerification) {
//        guard isVerifyButtonEnabled else { return }
//        
//        // 1. حفظ البيانات المجمعة في AppStorage
//        storedName = userData.name
//        storedCarbValue = userData.carbValue // تم حفظ قيمة الكارب
//        selectedAvatarImageName = userData.selectedAvatar.imageName
//        
//        // 2. إشارة للانتقال إلى CongratsView
//        DispatchQueue.main.async {
//            self.shouldNavigateToCongrats = true
//        }
//    }
//}
//














//
//  UserDataForVerification.swift
//  AllAble
//
//  Created by Wteen Alghamdy on 15/06/1447 AH.
//

import Foundation

/// هيكل البيانات المستخدم لتجميع معلومات المستخدم من InfoView لتمريرها إلى ViewModel
struct UserDataForVerification {
    let name: String
    let age: String // يفضل تمرير العمر أيضاً
    let carbValue: String
    let selectedAvatar: Avatar
}




















//
//import Foundation
//import Combine
//import SwiftUI
//
//// الهيكلية المستخدمة لتمرير البيانات من شاشة InfoView
//struct UserDataForVerification {
//    let name: String
//    let carbValue: String
//    let selectedAvatar: Avatar
//}
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
//    // 🆕 إشارة للـ View لكي تقوم بإنهاء الـ fullScreenCover بعد الحفظ
//    @Published var shouldEndOnboarding = false
//    
//    // 🆕 استخدام AppStorage لحفظ حالة إكمال التسجيل وبيانات المستخدم
//    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
//    @AppStorage("account.name") private var storedName: String = ""
//    @AppStorage("account.carbonValue") private var storedCarbValue: String = "15"
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
//    // 🛠️ وظيفة التحقق النهائية التي تحفظ البيانات وتطلق إشارة انتهاء التسجيل
//    func verifyCode(userData: UserDataForVerification) {
//        guard isVerifyButtonEnabled else { return }
//        
//        // 1. حفظ البيانات المجمعة
//        storedName = userData.name
//        storedCarbValue = userData.carbValue
//        selectedAvatarImageName = userData.selectedAvatar.imageName
//        
//        // 2. وضع علامة إكمال التسجيل (لتغيير الـ Root View في AllAbleApp)
//        hasCompletedOnboarding = true
//
//        // 3. إطلاق إشارة الإغلاق للـ VerificationView
//        DispatchQueue.main.async {
//            self.shouldEndOnboarding = true
//        }
//    }
//}















//
//// UserDataForVerification.swift
//import Foundation
//import SwiftUI
//
///// هيكل البيانات المستخدم لتجميع معلومات المستخدم من InfoView لتمريرها إلى ViewModel
//struct UserDataForVerification {
//    let name: String
//    let carbValue: String
//    let selectedAvatar: Avatar
//}

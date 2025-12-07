//
//  VerificationView.swift
//  AllAble
//
//  Created by Wteen Alghamdy on 15/06/1447 AH.
//



//
//import SwiftUI
//
//struct VerificationView: View {
//    @Environment(\.dismiss) var dismiss
//    @StateObject var viewModel = VerificationViewModel()
//    
//    // FIX: استقبال كل بيانات المستخدم بدلاً من Avatar فقط
//    let userData: UserDataForVerification
//    
//    // FIX: تعريف الألوان محلياً بدلاً من AppConstants
//    let backgroundColor = Color(red: 0.97, green: 0.96, blue: 0.92)
//    let brandBlueColor = Color(red: 0.1, green: 0.3, blue: 0.5)
//    let primaryColor = Color(red: 0.99, green: 0.85, blue: 0.33)
//    
//    @FocusState private var focusedField: Int?
//
//    var body: some View {
//        ZStack {
//            backgroundColor.edgesIgnoringSafeArea(.all)
//            
//            VStack(spacing: 0) {
//                // تم إزالة TopNavigationOverlay
//                
//                HStack(alignment: .top, spacing: 60) {
//                    
//                    VStack(alignment: .leading, spacing: 50) {
//                        Text("Parent Account Verification")
//                            .font(.title)
//                            .bold()
//                            .foregroundColor(brandBlueColor)
//                            .padding(.top, 50)
//                            .padding(.horizontal, 25)
//                        
//                        
//                        if viewModel.state == .enterEmail {
//                            EmailInputView(viewModel: viewModel, brandBlueColor: brandBlueColor, primaryColor: primaryColor)
//                        } else {
//                            VerificationCodeInputView(viewModel: viewModel, focusedField: $focusedField, primaryColor: primaryColor)
//                        }
//                        
//                        Spacer(minLength: 350)
//                    }
//                    .frame(width: 500)
//                    
//                    // صورة الأفاتار
//                    Image(userData.selectedAvatar.imageName) // FIX: استخدام الأفاتار الممرر
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 400, height: 500)
//                    
//                }
//                .padding(.horizontal, 50)
//                
//                Spacer()
//            }
//            .environment(\.layoutDirection, .rightToLeft) // FIX: تطبيق اتجاه العرض
//        }
//        .fullScreenCover(isPresented: $viewModel.shouldNavigateToCongrats) {
//            // FIX: الانتقال إلى CongratsView بعد التحقق
//            CongratsView(avatarImageName: userData.selectedAvatar.imageName)
//        }
//    }
//    
//    // MARK: - Helper Views
//    // ... (EmailInputView, VerificationCodeInputView, CodeDigitField يتم تعديلها لاستخدام الألوان الممررة) ...
//}
//
//// NOTE: يجب تعديل الـ Helper Views مثل EmailInputView و CodeDigitField لاستخدام الألوان الممررة
//// وإلا سأضطر لتعديلها هنا:
//
//struct EmailInputView: View {
//    @ObservedObject var viewModel: VerificationViewModel
//    let brandBlueColor: Color
//    let primaryColor: Color
//    
//    var body: some View {
//        // ... (Body with brandBlueColor, primaryColor used) ...
//        VStack(alignment: .leading, spacing: 20) {
//            Text("Parent Email")
//                .font(.title2)
//                .bold()
//                .foregroundColor(brandBlueColor)
//                .padding(.leading, 10)
//            
//            TextField("Enter your parent's email", text: $viewModel.parentEmail)
//                .font(.title2)
//                .foregroundColor(.gray)
//                .frame(height: 65)
//                .background(Color.white)
//                .cornerRadius(16)
//                .keyboardType(.emailAddress)
//                .multilineTextAlignment(.leading)
//                .padding(.horizontal, 20)
//                
//            
//            Button(action: viewModel.sendVerificationCode) {
//                Text("SEND CODE")
//                    .font(.title2.bold())
//                    .frame(width: 250, height: 60)
//                    .background(viewModel.isSendCodeButtonEnabled ? primaryColor : Color.gray.opacity(0.3))
//                    .foregroundColor(viewModel.isSendCodeButtonEnabled ? .black : .white)
//                    .cornerRadius(15)
//            }
//            .disabled(!viewModel.isSendCodeButtonEnabled)
//            .padding(.top, 20)
//        }
//        .frame(width: 450)
//    }
//}
//
//struct VerificationCodeInputView: View {
//    @ObservedObject var viewModel: VerificationViewModel
//    @FocusState.Binding var focusedField: Int?
//    let primaryColor: Color
//    
//    var body: some View {
//        VStack(alignment: .center, spacing: 40) {
//            Text("Enter the 4-digit verification code")
//                .font(.title2)
//                .foregroundColor(.gray)
//            
//            HStack(spacing: 20) {
//                ForEach(0..<4, id: \.self) { index in
//                    CodeDigitField(
//                        text: $viewModel.verificationCode[index],
//                        focusedField: $focusedField,
//                        currentIndex: index,
//                        primaryColor: primaryColor
//                    )
//                }
//            }
//            
//            Button(action: {
//                // FIX: تمرير بيانات المستخدم المحفوظة عند التحقق النهائي
//                viewModel.verifyCode(userData: userData)
//            }) {
//                Text("VERIFY")
//                    .font(.title2.bold())
//                    .frame(width: 250, height: 60)
//                    .background(viewModel.isVerifyButtonEnabled ? primaryColor : Color.gray.opacity(0.3))
//                    .foregroundColor(viewModel.isVerifyButtonEnabled ? .black : .white)
//                    .cornerRadius(15)
//            }
//            .disabled(!viewModel.isVerifyButtonEnabled)
//            .padding(.top, 20)
//        }
//        .frame(width: 450)
//        .onAppear {
//            focusedField = 0
//        }
//    }
//    
//    // CRITICAL: Must access userData from the parent view
//    @Environment(\.userData) var userData
//}
//
//
//// FIX: إضافة CodeDigitField ليتوافق مع الإعدادات الجديدة
//struct CodeDigitField: View {
//    @Binding var text: String
//    @FocusState.Binding var focusedField: Int?
//    let currentIndex: Int
//    let primaryColor: Color
//    
//    var body: some View {
//        TextField("", text: $text)
//            .foregroundColor(.black)
//            .frame(width: 80, height: 80)
//            .background(Color.white)
//            .cornerRadius(16)
//            .font(.largeTitle)
//            .multilineTextAlignment(.center)
//            .keyboardType(.numberPad)
//            .focused($focusedField, equals: currentIndex)
//            .overlay(
//                RoundedRectangle(cornerRadius: 16)
//                    .stroke(focusedField == currentIndex ? primaryColor : Color.gray.opacity(0.3), lineWidth: 3)
//            )
//            .onChange(of: text) { newValue in
//                if newValue.count > 1 { text = String(newValue.prefix(1)) }
//                if !newValue.isEmpty && currentIndex < 3 { focusedField = currentIndex + 1 }
//                if newValue.isEmpty && currentIndex > 0 { focusedField = currentIndex - 1 }
//            }
//    }
//}
//
//// MARK: - Environment Key for Data Passing (لتسهيل الوصول لـ userData في Helper Views)
//private struct UserDataKey: EnvironmentKey {
//    static let defaultValue = UserDataForVerification(name: "", carbValue: "15", selectedAvatar: Avatar.boyAvatar)
//}
//
//extension EnvironmentValues {
//    var userData: UserDataForVerification {
//        get { self[UserDataKey.self] }
//        set { self[UserDataKey.self] = newValue }
//    }
//}





//
//import SwiftUI
//
//struct VerificationView: View {
//    @Environment(\.dismiss) var dismiss
//    @StateObject var viewModel = VerificationViewModel()
//    
//    // FIX: استقبال كل بيانات المستخدم
//    let userData: UserDataForVerification
//    
//    // FIX: تعريف الألوان محلياً بدلاً من AppConstants
//    let backgroundColor = Color(red: 0.97, green: 0.96, blue: 0.92)
//    let brandBlueColor = Color(red: 0.1, green: 0.3, blue: 0.5)
//    let primaryColor = Color(red: 0.99, green: 0.85, blue: 0.33)
//    
//    @FocusState private var focusedField: Int?
//
//    var body: some View {
//        ZStack {
//            backgroundColor.edgesIgnoringSafeArea(.all)
//            
//            VStack(spacing: 0) {
//                
//                HStack(alignment: .top, spacing: 60) {
//                    
//                    VStack(alignment: .leading, spacing: 50) {
//                        Text("Parent Account Verification")
//                            .font(.title)
//                            .bold()
//                            .foregroundColor(brandBlueColor)
//                            .padding(.top, 50)
//                            .padding(.horizontal, 25)
//                        
//                        
//                        if viewModel.state == .enterEmail {
//                            EmailInputView(viewModel: viewModel, brandBlueColor: brandBlueColor, primaryColor: primaryColor)
//                        } else {
//                            VerificationCodeInputView(viewModel: viewModel, focusedField: $focusedField, primaryColor: primaryColor, userData: userData)
//                        }
//                        
//                        Spacer(minLength: 350)
//                    }
//                    .frame(width: 500)
//                    
//                    Image(userData.selectedAvatar.imageName)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 400, height: 500)
//                    
//                }
//                .padding(.horizontal, 50)
//                
//                Spacer()
//            }
//            .environment(\.layoutDirection, .rightToLeft) // FIX: تطبيق اتجاه العرض
//        }
//        .fullScreenCover(isPresented: $viewModel.shouldNavigateToCongrats) {
//            CongratsView(avatarImageName: userData.selectedAvatar.imageName)
//        }
//    }
//}
//
//// MARK: - Helper Views (يجب وضعها في نفس ملف VerificationView.swift)
//
//struct EmailInputView: View {
//    @ObservedObject var viewModel: VerificationViewModel
//    let brandBlueColor: Color
//    let primaryColor: Color
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 20) {
//            Text("Parent Email")
//                .font(.title2)
//                .bold()
//                .foregroundColor(brandBlueColor)
//                .padding(.leading, 10)
//            
//            TextField("Enter your parent's email", text: $viewModel.parentEmail)
//                .font(.title2)
//                .foregroundColor(.gray)
//                .frame(height: 65)
//                .background(Color.white)
//                .cornerRadius(16)
//                .keyboardType(.emailAddress)
//                .multilineTextAlignment(.leading)
//                .padding(.horizontal, 20)
//                
//            
//            Button(action: viewModel.sendVerificationCode) {
//                Text("SEND CODE")
//                    .font(.title2.bold())
//                    .frame(width: 250, height: 60)
//                    .background(viewModel.isSendCodeButtonEnabled ? primaryColor : Color.gray.opacity(0.3))
//                    .foregroundColor(viewModel.isSendCodeButtonEnabled ? .black : .white)
//                    .cornerRadius(15)
//            }
//            .disabled(!viewModel.isSendCodeButtonEnabled)
//            .padding(.top, 20)
//        }
//        .frame(width: 450)
//    }
//}
//
//struct VerificationCodeInputView: View {
//    @ObservedObject var viewModel: VerificationViewModel
//    @FocusState.Binding var focusedField: Int?
//    let primaryColor: Color
//    let userData: UserDataForVerification // استقبال بيانات المستخدم
//    
//    var body: some View {
//        VStack(alignment: .center, spacing: 40) {
//            Text("Enter the 4-digit verification code")
//                .font(.title2)
//                .foregroundColor(.gray)
//            
//            HStack(spacing: 20) {
//                ForEach(0..<4, id: \.self) { index in
//                    CodeDigitField(
//                        text: $viewModel.verificationCode[index],
//                        focusedField: $focusedField,
//                        currentIndex: index,
//                        primaryColor: primaryColor
//                    )
//                }
//            }
//            
//            Button(action: {
//                // استدعاء التحقق مع تمرير البيانات للحفظ
//                viewModel.verifyCode(userData: userData)
//            }) {
//                Text("VERIFY")
//                    .font(.title2.bold())
//                    .frame(width: 250, height: 60)
//                    .background(viewModel.isVerifyButtonEnabled ? primaryColor : Color.gray.opacity(0.3))
//                    .foregroundColor(viewModel.isVerifyButtonEnabled ? .black : .white)
//                    .cornerRadius(15)
//            }
//            .disabled(!viewModel.isVerifyButtonEnabled)
//            .padding(.top, 20)
//        }
//        .frame(width: 450)
//        .onAppear {
//            focusedField = 0
//        }
//    }
//}
//
//struct CodeDigitField: View {
//    @Binding var text: String
//    @FocusState.Binding var focusedField: Int?
//    let currentIndex: Int
//    let primaryColor: Color
//    
//    var body: some View {
//        TextField("", text: $text)
//            .foregroundColor(.black)
//            .frame(width: 80, height: 80)
//            .background(Color.white)
//            .cornerRadius(16)
//            .font(.largeTitle)
//            .multilineTextAlignment(.center)
//            .keyboardType(.numberPad)
//            .focused($focusedField, equals: currentIndex)
//            .overlay(
//                RoundedRectangle(cornerRadius: 16)
//                    .stroke(focusedField == currentIndex ? primaryColor : Color.gray.opacity(0.3), lineWidth: 3)
//            )
//            .onChange(of: text) { newValue in
//                if newValue.count > 1 { text = String(newValue.prefix(1)) }
//                if !newValue.isEmpty && currentIndex < 3 { focusedField = currentIndex + 1 }
//                if newValue.isEmpty && currentIndex > 0 { focusedField = currentIndex - 1 }
//            }
//    }
//}
















//
//import SwiftUI
//
//struct VerificationView: View {
//    @Environment(\.dismiss) var dismiss
//    @StateObject var viewModel = VerificationViewModel()
//    
//    // البيانات القادمة من InfoView
//    let userData: UserDataForVerification
//    
//    @FocusState private var focusedField: Int?
//    @State private var currentPage = 2
//    
//    // 🛠️ FIX: تعريف الألوان محلياً
//    let backgroundColor = Color(red: 0.97, green: 0.96, blue: 0.92)
//    let brandBlueColor = Color(red: 0.1, green: 0.3, blue: 0.5)
//    let primaryColor = Color(red: 0.99, green: 0.85, blue: 0.33)
//
//    var body: some View {
//        ZStack {
//            backgroundColor.edgesIgnoringSafeArea(.all)
//            
//            VStack(spacing: 0) {
//                
//                Spacer().frame(height: 200)
//
//                HStack(alignment: .top, spacing: 60) {
//                    
//                    VStack(alignment: .leading, spacing: 50) {
//                        Text("Parent Account Verification")
//                            .font(.title)
//                            .bold()
//                            .foregroundColor(brandBlueColor)
//                            .padding(.top, 50)
//                            .padding(.horizontal, 25)
//                        
//                        
//                        VStack(alignment: .leading, spacing: 30) {
//                            if viewModel.state == .enterEmail {
//                                EmailInputView(viewModel: viewModel, brandBlueColor: brandBlueColor, primaryColor: primaryColor)
//                            } else {
//                                VerificationCodeInputView(viewModel: viewModel, focusedField: $focusedField, primaryColor: primaryColor, userData: userData)
//                            }
//                        }
//
//                        Spacer(minLength: 350)
//                    }
//                    .frame(width: 500)
//                    
//                    Image(userData.selectedAvatar.imageName)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 400, height: 500)
//                    
//                }
//                .padding(.horizontal, 50)
//                
//                Spacer()
//            }
//            
//            
//            
////            .environment(\.layoutDirection, .rightToLeft)
//            
//            
//            
//            
//        }
////        ..onChange(of: viewModel.shouldEndOnboarding) { newValue in
////        if newValue {
////            dismiss() // إغلاق الـ fullScreenCover والانتقال لـ MainPage
////            }
////        }
//    }
//    
//    
//    
//    // MARK: - Helper Views
//    
//    
//    struct EmailInputView: View {
//        @ObservedObject var viewModel: VerificationViewModel
//        let brandBlueColor: Color
//        let primaryColor: Color
//        
//        var body: some View {
//            VStack(alignment: .leading, spacing: 20) {
//                Text("Parent Email")
//                    .font(.title2)
//                    .bold()
//                    .foregroundColor(brandBlueColor)
//                    .padding(.leading, 10)
//                
//                TextField("Enter your parent's email", text: $viewModel.parentEmail)
//                    .font(.title2)
//                    .foregroundColor(.gray)
//                    .frame(height: 65)
//                    .background(Color.white)
//                    .cornerRadius(16)
//                    .keyboardType(.emailAddress)
//                    .multilineTextAlignment(.leading)
//                    .padding(.horizontal, 20)
//                    
//
//                
//                Button(action: viewModel.sendVerificationCode) {
//                    Text("SEND CODE")
//                        .font(.title2.bold())
//                        .frame(width: 250, height: 60)
//                        .background(viewModel.isSendCodeButtonEnabled ? primaryColor : Color.gray.opacity(0.3))
//                        .foregroundColor(viewModel.isSendCodeButtonEnabled ? .black : .white)
//                        .cornerRadius(15)
//                }
//                .disabled(!viewModel.isSendCodeButtonEnabled)
//                .padding(.top, 20)
//            }
//            .frame(width: 450)
//        }
//    }
//
//    struct VerificationCodeInputView: View {
//        @ObservedObject var viewModel: VerificationViewModel
//        @FocusState.Binding var focusedField: Int?
//        let primaryColor: Color
//        let userData: UserDataForVerification // استقبال بيانات المستخدم
//        
//        var body: some View {
//            VStack(alignment: .center, spacing: 40) {
//                Text("Enter the 4-digit verification code")
//                    .font(.title2)
//                    .foregroundColor(.gray)
//                
//                HStack(spacing: 20) {
//                    ForEach(0..<4, id: \.self) { index in
//                        CodeDigitField(
//                            text: $viewModel.verificationCode[index],
//                            focusedField: $focusedField,
//                            currentIndex: index,
//                            primaryColor: primaryColor
//                        )
//                    }
//                }
//                
//                Button(action: {
//                    // استدعاء التحقق مع تمرير البيانات للحفظ
//                    viewModel.verifyCode(userData: userData)
//                }) {
//                    Text("VERIFY")
//                        .font(.title2.bold())
//                        .frame(width: 250, height: 60)
//                        .background(viewModel.isVerifyButtonEnabled ? primaryColor : Color.gray.opacity(0.3))
//                        .foregroundColor(viewModel.isVerifyButtonEnabled ? .black : .white)
//                        .cornerRadius(15)
//                }
//                .disabled(!viewModel.isVerifyButtonEnabled)
//                .padding(.top, 20)
//            }
//            .frame(width: 450)
//            .onAppear {
//                focusedField = 0
//            }
//        }
//    }
//
//    struct CodeDigitField: View {
//        @Binding var text: String
//        @FocusState.Binding var focusedField: Int?
//        let currentIndex: Int
//        let primaryColor: Color
//        
//        var body: some View {
//            TextField("", text: $text)
//                .foregroundColor(.black)
//                .frame(width: 80, height: 80)
//                .background(Color.white)
//                .cornerRadius(16)
//                .font(.largeTitle)
//                .multilineTextAlignment(.center)
//                .keyboardType(.numberPad)
//                .focused($focusedField, equals: currentIndex)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 16)
//                        .stroke(focusedField == currentIndex ? primaryColor : Color.gray.opacity(0.3), lineWidth: 3)
//                )
//                .onChange(of: text) { newValue in
//                    if newValue.count > 1 { text = String(newValue.prefix(1)) }
//                    if !newValue.isEmpty && currentIndex < 3 { focusedField = currentIndex + 1 }
//                    if newValue.isEmpty && currentIndex > 0 { focusedField = currentIndex - 1 }
//                }
//        }
//    }
//}
//#Preview {
//    let mockAvatar = Avatar(name: "Mock Boy", imageName: "AvatarBoy")
//    
//    let mockUserData = UserDataForVerification(
//        name: "Mock User",
//        carbValue: "10",
//        selectedAvatar: mockAvatar
//    )
//    
//    return VerificationView(userData: mockUserData)
//}



















//
//  VerificationView.swift
//  AllAble
//
//  Created by Wteen Alghamdy on 15/06/1447 AH.
//

import SwiftUI

struct VerificationView: View {
    @Environment(\.dismiss) var dismiss // ✅ لتشغيل الإغلاق
    @StateObject var viewModel = VerificationViewModel()
    
    // البيانات القادمة من InfoView
    let userData: UserDataForVerification
    
    @FocusState private var focusedField: Int?
    
    // 🛠️ FIX: تعريف الألوان محلياً
    let backgroundColor = Color(red: 0.97, green: 0.96, blue: 0.92)
    let brandBlueColor = Color(red: 0.1, green: 0.3, blue: 0.5)
    let primaryColor = Color(red: 0.99, green: 0.85, blue: 0.33)

    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                
                Spacer().frame(height: 200)

                HStack(alignment: .top, spacing: 60) {
                    
                    VStack(alignment: .leading, spacing: 50) {
                        Text("Parent Account Verification")
                            .font(.title)
                            .bold()
                            .foregroundColor(brandBlueColor)
                            .padding(.top, 50)
                            .padding(.horizontal, 25)
                        
                        
                        VStack(alignment: .leading, spacing: 30) {
                            if viewModel.state == .enterEmail {
                                EmailInputView(viewModel: viewModel, brandBlueColor: brandBlueColor, primaryColor: primaryColor)
                            } else {
                                // تمرير بيانات المستخدم للحفظ عند التحقق
                                VerificationCodeInputView(viewModel: viewModel, focusedField: $focusedField, primaryColor: primaryColor, userData: userData)
                            }
                        }

                        Spacer(minLength: 350)
                    }
                    .frame(width: 500)
                    
                    Image(userData.selectedAvatar.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 400, height: 500)
                    
                }
                .padding(.horizontal, 50)
                
                Spacer()
            }
        }
        // 🔥 CRITICAL FIX: يغلق شاشة التحقق (الـ modal) عند إشارة ViewModel بالنجاح
        .onChange(of: viewModel.shouldEndOnboarding) { newValue in
            if newValue {
                dismiss() // إغلاق الـ fullScreenCover/Sheet
            }
        }
//        .environment(\.layoutDirection, .rightToLeft)
    }
    
    
    // MARK: - Helper Views
    
    struct EmailInputView: View {
        @ObservedObject var viewModel: VerificationViewModel
        let brandBlueColor: Color
        let primaryColor: Color
        
        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                Text("Parent Email")
                    .font(.title2)
                    .bold()
                    .foregroundColor(brandBlueColor)
                    .padding(.leading, 10)
                
                TextField("Enter your parent's email", text: $viewModel.parentEmail)
                    .font(.title2)
                    .foregroundColor(.gray)
                    .frame(height: 65)
                    .background(Color.white)
                    .cornerRadius(16)
                    .keyboardType(.emailAddress)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                    
                
                Button(action: viewModel.sendVerificationCode) {
                    Text("SEND CODE")
                        .font(.title2.bold())
                        .frame(width: 250, height: 60)
                        .background(viewModel.isSendCodeButtonEnabled ? primaryColor : Color.gray.opacity(0.3))
                        .foregroundColor(viewModel.isSendCodeButtonEnabled ? .black : .white)
                        .cornerRadius(15)
                }
                .disabled(!viewModel.isSendCodeButtonEnabled)
                .padding(.top, 20)
            }
            .frame(width: 450)
        }
    }

    struct VerificationCodeInputView: View {
        @ObservedObject var viewModel: VerificationViewModel
        @FocusState.Binding var focusedField: Int?
        let primaryColor: Color
        let userData: UserDataForVerification
        
        var body: some View {
            VStack(alignment: .center, spacing: 40) {
                Text("Enter the 4-digit verification code")
                    .font(.title2)
                    .foregroundColor(.gray)
                
                HStack(spacing: 20) {
                    ForEach(0..<4, id: \.self) { index in
                        CodeDigitField(
                            text: $viewModel.verificationCode[index],
                            focusedField: $focusedField,
                            currentIndex: index,
                            primaryColor: primaryColor
                        )
                    }
                }
                
                Button(action: {
                    // استدعاء التحقق مع تمرير البيانات للحفظ
                    viewModel.verifyCode(userData: userData)
                }) {
                    Text("VERIFY")
                        .font(.title2.bold())
                        .frame(width: 250, height: 60)
                        .background(viewModel.isVerifyButtonEnabled ? primaryColor : Color.gray.opacity(0.3))
                        .foregroundColor(viewModel.isVerifyButtonEnabled ? .black : .white)
                        .cornerRadius(15)
                }
                .disabled(!viewModel.isVerifyButtonEnabled)
                .padding(.top, 20)
            }
            .frame(width: 450)
            .onAppear {
                focusedField = 0
            }
        }
    }

    struct CodeDigitField: View {
        @Binding var text: String
        @FocusState.Binding var focusedField: Int?
        let currentIndex: Int
        let primaryColor: Color
        
        var body: some View {
            TextField("", text: $text)
                .foregroundColor(.black)
                .frame(width: 80, height: 80)
                .background(Color.white)
                .cornerRadius(16)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .focused($focusedField, equals: currentIndex)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(focusedField == currentIndex ? primaryColor : Color.gray.opacity(0.3), lineWidth: 3)
                )
                .onChange(of: text) { newValue in
                    if newValue.count > 1 { text = String(newValue.prefix(1)) }
                    if !newValue.isEmpty && currentIndex < 3 { focusedField = currentIndex + 1 }
                    if newValue.isEmpty && currentIndex > 0 { focusedField = currentIndex - 1 }
                }
        }
    }
}

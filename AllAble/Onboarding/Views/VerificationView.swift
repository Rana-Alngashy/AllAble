//
//  VerificationView.swift
//  AllAble
//
//  Created by Wteen Alghamdy on 15/06/1447 AH.
//
//
import SwiftUI

struct VerificationView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = VerificationViewModel()
    
    let userData: UserDataForVerification
    @FocusState private var focusedField: Int?
    
    let backgroundColor = Color(red: 0.97, green: 0.96, blue: 0.92)
    let brandBlueColor = Color(red: 0.1, green: 0.3, blue: 0.5)
    let primaryColor = Color(red: 0.99, green: 0.85, blue: 0.33)
    
    @Environment(\.horizontalSizeClass) private var hSize
    private var isCompact: Bool { hSize == .compact }   // iPhone
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: isCompact ? 24 : 60) {
                    
                    Spacer().frame(height: isCompact ? 20 : 200)
                    
                    if isCompact {
                        // 📱 iPhone – عمودي
                        VStack(spacing: 30) {
                            avatarSection
                            formSection
                        }
                        .padding(.horizontal, 20)
                    } else {
                        // 💻 iPad – أفقي
                        HStack(alignment: .top, spacing: 60) {
                            formSection
                                .frame(width: 500)
                            
                            avatarSection
                                .frame(width: 400)
                        }
                        .padding(.horizontal, 50)
                    }
                }
            }
        }
        .onChange(of: viewModel.shouldEndOnboarding) { newValue in
            if newValue {
                dismiss()
            }
        }
    }
    
    // MARK: - Form Section
    
    private var formSection: some View {
        VStack(alignment: .leading, spacing: isCompact ? 24 : 40) {
            
            Text("Parent Account Verification")
                .font(isCompact ? .title3 : .title)
                .bold()
                .foregroundColor(brandBlueColor)
                .padding(.top, isCompact ? 10 : 50)
            
            if viewModel.state == .enterEmail {
                EmailInputView(
                    viewModel: viewModel,
                    brandBlueColor: brandBlueColor,
                    primaryColor: primaryColor,
                    isCompact: isCompact
                )
            } else {
                VerificationCodeInputView(
                    viewModel: viewModel,
                    focusedField: $focusedField,
                    primaryColor: primaryColor,
                    userData: userData,
                    isCompact: isCompact
                )
            }
            
            Spacer(minLength: isCompact ? 30 : 120)
        }
    }
    
    // MARK: - Avatar Section
    
    private var avatarSection: some View {
        Image(userData.selectedAvatar.imageName)
            .resizable()
            .scaledToFit()
            .frame(
                width: isCompact ? 200 : 400,
                height: isCompact ? 260 : 500
            )
    }
    
    // MARK: - Helper Views
    
    struct EmailInputView: View {
        @ObservedObject var viewModel: VerificationViewModel
        let brandBlueColor: Color
        let primaryColor: Color
        let isCompact: Bool
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text("Parent Email")
                    .font(isCompact ? .body : .title2)
                    .bold()
                    .foregroundColor(brandBlueColor)
                
                TextField("Enter your parent's email", text: $viewModel.parentEmail)
                    .font(.body)
                    .foregroundColor(.gray)
                    .frame(height: isCompact ? 50 : 65)
                    .background(Color.white)
                    .cornerRadius(16)
                    .keyboardType(.emailAddress)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 12)
                    
                Button(action: viewModel.sendVerificationCode) {
                    Text("SEND CODE")
                        .font(isCompact ? .title3 : .title2)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .frame(height: isCompact ? 50 : 60)
                        .background(viewModel.isSendCodeButtonEnabled ? primaryColor : Color.gray.opacity(0.3))
                        .foregroundColor(viewModel.isSendCodeButtonEnabled ? .black : .white)
                        .cornerRadius(15)
                }
                .disabled(!viewModel.isSendCodeButtonEnabled)
                .padding(.top, 10)
            }
        }
    }

    struct VerificationCodeInputView: View {
        @ObservedObject var viewModel: VerificationViewModel
        @FocusState.Binding var focusedField: Int?
        let primaryColor: Color
        let userData: UserDataForVerification
        let isCompact: Bool
        
        var body: some View {
            VStack(alignment: .center, spacing: isCompact ? 24 : 40) {
                
                Text("Enter the 4-digit verification code")
                    .font(isCompact ? .body : .title2)
                    .foregroundColor(.gray)
                
                HStack(spacing: isCompact ? 12 : 20) {
                    ForEach(0..<4, id: \.self) { index in
                        CodeDigitField(
                            text: $viewModel.verificationCode[index],
                            focusedField: $focusedField,
                            currentIndex: index,
                            primaryColor: primaryColor,
                            isCompact: isCompact
                        )
                    }
                }
                
                Button(action: {
                    viewModel.verifyCode(userData: userData)
                }) {
                    Text("VERIFY")
                        .font(isCompact ? .title3 : .title2)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .frame(height: isCompact ? 50 : 60)
                        .background(viewModel.isVerifyButtonEnabled ? primaryColor : Color.gray.opacity(0.3))
                        .foregroundColor(viewModel.isVerifyButtonEnabled ? .black : .white)
                        .cornerRadius(15)
                }
                .disabled(!viewModel.isVerifyButtonEnabled)
                .padding(.top, 10)
            }
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
        let isCompact: Bool
        
        var body: some View {
            TextField("", text: $text)
                .foregroundColor(.black)
                .frame(
                    width: isCompact ? 50 : 80,
                    height: isCompact ? 50 : 80
                )
                .background(Color.white)
                .cornerRadius(16)
                .font(isCompact ? .title2 : .largeTitle)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .focused($focusedField, equals: currentIndex)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            focusedField == currentIndex ? primaryColor : Color.gray.opacity(0.3),
                            lineWidth: 3
                        )
                )
                .onChange(of: text) { newValue in
                    if newValue.count > 1 { text = String(newValue.prefix(1)) }
                    if !newValue.isEmpty && currentIndex < 3 { focusedField = currentIndex + 1 }
                    if newValue.isEmpty && currentIndex > 0 { focusedField = currentIndex - 1 }
                }
        }
    }
}

//import SwiftUI
//
//struct VerificationView: View {
//    @Environment(\.dismiss) var dismiss // ✅ لتشغيل الإغلاق
//    @StateObject var viewModel = VerificationViewModel()
//    
//    // البيانات القادمة من InfoView
//    let userData: UserDataForVerification
//    
//    @FocusState private var focusedField: Int?
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
//                                // تمرير بيانات المستخدم للحفظ عند التحقق
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
//        }
//        // 🔥 CRITICAL FIX: يغلق شاشة التحقق (الـ modal) عند إشارة ViewModel بالنجاح
//        .onChange(of: viewModel.shouldEndOnboarding) { newValue in
//            if newValue {
//                dismiss() // إغلاق الـ fullScreenCover/Sheet
//            }
//        }
////        .environment(\.layoutDirection, .rightToLeft)
//    }
//    
//    
//    // MARK: - Helper Views
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
//        let userData: UserDataForVerification
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

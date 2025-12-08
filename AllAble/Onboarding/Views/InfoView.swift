//
//  InfoView.swift
//  AllAble
//
//  Created by Wteen Alghamdy on 15/06/1447 AH.
//
//
//import SwiftUI
//
//struct InfoView: View {
//    @StateObject var viewModel = InfoViewModel()
//    let selectedAvatar: Avatar
//    
//    // FIX: تعريف الألوان محلياً بدلاً من AppConstants
//    let backgroundColor = Color(red: 0.97, green: 0.96, blue: 0.92)
//    let brandBlueColor = Color(red: 0.1, green: 0.3, blue: 0.5) // افتراض لون أزرق للبراند
//    let primaryColor = Color(red: 0.99, green: 0.85, blue: 0.33)
//    
//    var body: some View {
//        ZStack {
//            backgroundColor.edgesIgnoringSafeArea(.all)
//            
//            VStack(spacing: 0) {
//                // تم إزالة TopNavigationOverlay (إذا لم يكن جزءاً من المشروع الكامل)
//                
//                HStack(alignment: .top, spacing: 60) {
//                    
//                    VStack(alignment: .leading, spacing: 30) {
//                        Text("User Information")
//                            .font(.largeTitle)
//                            .bold()
//                            .foregroundColor(.gray)
//                            .padding(.top, 50)
//                        
//                        InfoInputField(title: "Name", text: $viewModel.name, brandBlueColor: brandBlueColor)
//                        InfoInputField(title: "Age", text: $viewModel.age, brandBlueColor: brandBlueColor)
//                            .keyboardType(.numberPad)
//                        
//                        CarbValueInputField(
//                            title: "Carb Value",
//                            text: $viewModel.carbValue,
//                            isExplanationVisible: $viewModel.isCarbExplanationVisible,
//                            toggleAction: viewModel.toggleCarbExplanation,
//                            brandBlueColor: brandBlueColor
//                        )
//                        .keyboardType(.numberPad)
//
//                        if viewModel.isCarbExplanationVisible {
//                            Text("Carb Value هو نسبة الكاربوهيدرات إلى الأنسولين (مثال: 10 جرام كارب لكل 1 وحدة أنسولين).")
//                                .font(.callout)
//                                .foregroundColor(brandBlueColor)
//                                .padding(.horizontal, 20)
//                                .padding(.top, -20)
//                        }
//
//                        Spacer()
//                        
//                        Button(action: viewModel.handleNext) {
//                            Text("NEXT")
//                                .font(.title2.bold())
//                                .frame(width: 250, height: 60)
//                                .background(viewModel.isNextButtonEnabled ? primaryColor : Color.gray.opacity(0.3))
//                                .foregroundColor(viewModel.isNextButtonEnabled ? .black : .white)
//                                .cornerRadius(15)
//                        }
//                        .disabled(!viewModel.isNextButtonEnabled)
//                        .padding(.bottom, 50)
//                    }
//                    .frame(width: 500) // عرض ثابت لـ VStack
//
//                    // صورة الأفاتار
//                    Image(selectedAvatar.imageName)
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
//        .fullScreenCover(isPresented: $viewModel.shouldNavigateToVerification) {
//            // FIX: تمرير كل بيانات المستخدم التي تم جمعها
//            let userData = UserDataForVerification(
//                name: viewModel.name,
//                carbValue: viewModel.carbValue,
//                selectedAvatar: selectedAvatar
//            )
//            VerificationView(userData: userData)
//        }
//    }
//    
//    // MARK: - Helper Views
//    
//    struct InfoInputField: View {
//        let title: String
//        @Binding var text: String
//        let brandBlueColor: Color
//        
//        var body: some View {
//            VStack(alignment: .leading) {
//                Text(title)
//                    .font(.title2)
//                    .bold()
//                    .foregroundColor(brandBlueColor) // FIX: استخدام اللون الممرر
//                    .padding(.leading, 10)
//                
//                TextField("", text: $text)
//                    .font(.title2)
//                    .foregroundColor(.gray)
//                    .frame(height: 65)
//                    .background(Color.white)
//                    .cornerRadius(16)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 16)
//                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//                    )
//                    .multilineTextAlignment(.leading)
//                    .padding(.horizontal, 20)
//            }
//            .frame(width: 450)
//        }
//    }
//    
//    struct CarbValueInputField: View {
//        let title: String
//        @Binding var text: String
//        @Binding var isExplanationVisible: Bool
//        let toggleAction: () -> Void
//        let brandBlueColor: Color
//        
//        var body: some View {
//            HStack(spacing: 10) {
//                InfoInputField(title: title, text: $text, brandBlueColor: brandBlueColor)
//                
//                Button(action: toggleAction) {
//                    Image(systemName: "questionmark.circle.fill")
//                        .foregroundColor(brandBlueColor) // FIX: استخدام اللون الممرر
//                        .font(.title2)
//                }
//                .padding(.bottom, 10)
//            }
//        }
//    }
//}










//
//import SwiftUI
//
//struct InfoView: View {
//    @StateObject var viewModel = InfoViewModel()
//    let selectedAvatar: Avatar
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
//            
//            VStack(spacing: 0) {
//                
//                Spacer().frame(height: 200)
//                HStack(alignment: .top, spacing: 60) {
//                    
//                    VStack(alignment: .leading, spacing: 30) {
//                        Text("User Information")
//                            .font(.largeTitle)
//                            .bold()
//                            .foregroundColor(.gray)
//                            .padding(.top, 50)
//                        
//                        InfoInputField(title: "Name", text: $viewModel.name, brandBlueColor: brandBlueColor)
//                        
//                        InfoInputField(title: "Age", text: $viewModel.age, brandBlueColor: brandBlueColor)
//                            .keyboardType(.numberPad)
//                        
//                        CarbValueInputField(
//                            title: "Carb Value",
//                            text: $viewModel.carbValue,
//                            isExplanationVisible: $viewModel.isCarbExplanationVisible,
//                            toggleAction: viewModel.toggleCarbExplanation,
//                            brandBlueColor: brandBlueColor
//                        )
//                        .keyboardType(.numberPad)
//
//                        if viewModel.isCarbExplanationVisible {
//                            Text("Carb Value هو نسبة الكاربوهيدرات إلى الأنسولين (مثال: 10 جرام كارب لكل 1 وحدة أنسولين).")
//                                .font(.callout)
//                                .foregroundColor(brandBlueColor)
//                                .padding(.horizontal, 20)
//                                .padding(.top, -20)
//                        }
//
//                        Spacer()
//                        
//                        Button(action: viewModel.handleNext) {
//                            Text("NEXT")
//                                .font(.title2.bold())
//                                .frame(width: 250, height: 60)
//                                .background(viewModel.isNextButtonEnabled ? primaryColor : Color.gray.opacity(0.3))
//                                .foregroundColor(viewModel.isNextButtonEnabled ? .black : .white)
//                                .cornerRadius(15)
//                        }
//                        .disabled(!viewModel.isNextButtonEnabled)
//                        .padding(.bottom, 50)
//                    }
//                    .frame(width: 500)
//
//                    Image(selectedAvatar.imageName)
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
//            
//        }
//        .fullScreenCover(isPresented: $viewModel.shouldNavigateToVerification) {
//            // 🛠️ FIX: تمرير كل بيانات المستخدم التي تم جمعها
//            let userData = UserDataForVerification(
//                name: viewModel.name,
//                carbValue: viewModel.carbValue,
//                selectedAvatar: selectedAvatar
//            )
//            VerificationView(userData: userData)
//        }
//    }
//    
//    // MARK: - Helper Views
//    
//    struct InfoInputField: View {
//        let title: String
//        @Binding var text: String
//        let brandBlueColor: Color
//        
//        var body: some View {
//            VStack(alignment: .leading) {
//                Text(title)
//                    .font(.title2)
//                    .bold()
//                    .foregroundColor(brandBlueColor)
//                    .padding(.leading, 10)
//                
//                TextField("", text: $text)
//                    .font(.title2)
//                    .foregroundColor(.black)
//                    .frame(height: 65)
//                    .background(Color.white)
//                    .cornerRadius(16)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 16)
//                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//                    )
//                    .multilineTextAlignment(.leading)
//                    .padding(.horizontal, 20)
//            }
//            .frame(width: 450)
//        }
//    }
//    
//    struct CarbValueInputField: View {
//        let title: String
//        @Binding var text: String
//        @Binding var isExplanationVisible: Bool
//        let toggleAction: () -> Void
//        let brandBlueColor: Color
//        
//        var body: some View {
//            HStack(spacing: 10) {
//                InfoInputField(title: title, text: $text, brandBlueColor: brandBlueColor)
//                
//                Button(action: toggleAction) {
//                    Image(systemName: "questionmark.circle.fill")
//                        .foregroundColor(brandBlueColor)
//                        .font(.title2)
//                }
//                .padding(.bottom, 10)
//            }
//        }
//    }
//}
//#Preview {
//    // يجب إنشاء كائن Avatar وهمي لتشغيل الـ View
//    // NOTE: يجب أن يكون Avatar struct مُعرّفاً ومُتاحاً في هذا النطاق
//    let mockAvatar = Avatar(name: "Mock Boy", imageName: "AvatarBoy")
//    
//    return InfoView(selectedAvatar: mockAvatar)
//}
//







//
//  InfoView.swift
//  AllAble
//
//  Created by Wteen Alghamdy on 15/06/1447 AH.
//
//
//import SwiftUI
//
//struct InfoView: View {
//    @StateObject var viewModel = InfoViewModel()
//    let selectedAvatar: Avatar
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
//                HStack(alignment: .top, spacing: 60) {
//                    
//                    VStack(alignment: .leading, spacing: 30) {
//                        Text("User Information")
//                            .font(.largeTitle)
//                            .bold()
//                            .foregroundColor(.gray)
//                            .padding(.top, 50)
//                        
//                        InfoInputField(title: "Name", text: $viewModel.name, brandBlueColor: brandBlueColor)
//                        
//                        InfoInputField(title: "Age", text: $viewModel.age, brandBlueColor: brandBlueColor)
//                            .keyboardType(.numberPad)
//                        
//                        CarbValueInputField(
//                            title: "Carb Value",
//                            text: $viewModel.carbValue,
//                            isExplanationVisible: $viewModel.isCarbExplanationVisible,
//                            toggleAction: viewModel.toggleCarbExplanation,
//                            brandBlueColor: brandBlueColor
//                        )
//                        .keyboardType(.numberPad)
//
//                        if viewModel.isCarbExplanationVisible {
//                            Text("Carb Value هو نسبة الكاربوهيدرات إلى الأنسولين (مثال: 10 جرام كارب لكل 1 وحدة أنسولين).")
//                                .font(.callout)
//                                .foregroundColor(brandBlueColor)
//                                .padding(.horizontal, 20)
//                                .padding(.top, -20)
//                        }
//
//                        Spacer()
//                        
//                        Button(action: viewModel.handleNext) {
//                            Text("NEXT")
//                                .font(.title2.bold())
//                                .frame(width: 250, height: 60)
//                                .background(viewModel.isNextButtonEnabled ? primaryColor : Color.gray.opacity(0.3))
//                                .foregroundColor(viewModel.isNextButtonEnabled ? .black : .white)
//                                .cornerRadius(15)
//                        }
//                        .disabled(!viewModel.isNextButtonEnabled)
//                        .padding(.bottom, 50)
//                    }
//                    .frame(width: 500)
//
//                    Image(selectedAvatar.imageName)
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
//        // 🔥 CRITICAL FIX: تمرير كل بيانات المستخدم التي تم جمعها لصفحة التحقق
//        .fullScreenCover(isPresented: $viewModel.shouldNavigateToVerification) {
//            let userData = UserDataForVerification(
//                name: viewModel.name,
//                age: viewModel.age,
//                carbValue: viewModel.carbValue,
//                selectedAvatar: selectedAvatar
//            )
//            VerificationView(userData: userData)
//        }
//    }
//    
//    // ... (Helper Views) ...
//    struct InfoInputField: View {
//        let title: String
//        @Binding var text: String
//        let brandBlueColor: Color
//        // ... (Body) ...
//        var body: some View {
//            VStack(alignment: .leading) {
//                Text(title)
//                    .font(.title2)
//                    .bold()
//                    .foregroundColor(brandBlueColor)
//                    .padding(.leading, 10)
//                
//                TextField("", text: $text)
//                    .font(.title2)
//                    .foregroundColor(.black)
//                    .frame(height: 65)
//                    .background(Color.white)
//                    .cornerRadius(16)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 16)
//                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//                    )
//                    .multilineTextAlignment(.leading)
//                    .padding(.horizontal, 20)
//            }
//            .frame(width: 450)
//        }
//    }
//    
//    struct CarbValueInputField: View {
//        let title: String
//        @Binding var text: String
//        @Binding var isExplanationVisible: Bool
//        let toggleAction: () -> Void
//        let brandBlueColor: Color
//        
//        var body: some View {
//            HStack(spacing: 10) {
//                InfoInputField(title: title, text: $text, brandBlueColor: brandBlueColor)
//                
//                Button(action: toggleAction) {
//                    Image(systemName: "questionmark.circle.fill")
//                        .foregroundColor(brandBlueColor)
//                        .font(.title2)
//                }
//                .padding(.bottom, 10)
//            }
//        }
//    }
//}



import SwiftUI

struct InfoView: View {
    @StateObject var viewModel = InfoViewModel()
    let selectedAvatar: Avatar
    
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
                        // 📱 iPhone: عمودي
                        VStack(spacing: 30) {
                            avatarSection
                            formSection
                        }
                        .padding(.horizontal, 20)
                    } else {
                        // 💻 iPad: أفقي (كما كان)
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
//        .environment(\.layoutDirection, .rightToLeft)
        .fullScreenCover(isPresented: $viewModel.shouldNavigateToVerification) {
            let userData = UserDataForVerification(
                name: viewModel.name,
                age: viewModel.age,
                carbValue: viewModel.carbValue,
                selectedAvatar: selectedAvatar
            )
            VerificationView(userData: userData)
        }
    }
    
    // MARK: - Form Section
    
    private var formSection: some View {
        VStack(alignment: .leading, spacing: isCompact ? 20 : 30) {
            
            Text("Title.UserInfo")
                .font(isCompact ? .title2 : .largeTitle)
                .bold()
                .foregroundColor(.gray)
                .padding(.top, isCompact ? 10 : 50)
            
            InfoInputField(
                title: "Account.Name",                text: $viewModel.name,
                brandBlueColor: brandBlueColor,
                isCompact: isCompact
            )
            
            InfoInputField(
                title: "Account.Age",                text: $viewModel.age,
                brandBlueColor: brandBlueColor,
                isCompact: isCompact
            )
            .keyboardType(.numberPad)
            
            CarbValueInputField(
                title: "Account.CarbonValue",                text: $viewModel.carbValue,
                isExplanationVisible: $viewModel.isCarbExplanationVisible,
                toggleAction: viewModel.toggleCarbExplanation,
                brandBlueColor: brandBlueColor,
                isCompact: isCompact
            )
            .keyboardType(.numberPad)
            
            if viewModel.isCarbExplanationVisible {
                Text("Explanation.CarbValue")                    .font(.callout)
                    .foregroundColor(brandBlueColor)
                    .padding(.horizontal, 12)
            }

            Spacer(minLength: isCompact ? 20 : 40)
            
            Button(action: viewModel.handleNext) {
                Text("Button.Next")                    .font(isCompact ? .title3 : .title2)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .frame(height: isCompact ? 50 : 60)
                    .background(viewModel.isNextButtonEnabled ? primaryColor : Color.gray.opacity(0.3))
                    .foregroundColor(viewModel.isNextButtonEnabled ? .black : .white)
                    .cornerRadius(15)
            }
            .disabled(!viewModel.isNextButtonEnabled)
            .padding(.bottom, isCompact ? 20 : 50)
        }
    }
    
    // MARK: - Avatar Section
    
    private var avatarSection: some View {
        Image(selectedAvatar.imageName)
            .resizable()
            .scaledToFit()
            .frame(
                width: isCompact ? 200 : 400,
                height: isCompact ? 260 : 500
            )
    }
    
    // MARK: - Helper Views
    
    struct InfoInputField: View {
        let title: String
        @Binding var text: String
        let brandBlueColor: Color
        let isCompact: Bool
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(LocalizedStringKey(title))
                    .font(isCompact ? .body : .title2)
                    .bold()
                    .foregroundColor(brandBlueColor)
                    .padding(.leading, 6)
                
                TextField("", text: $text)
                    .font(.body)
                    .foregroundColor(.black)
                    .frame(height: isCompact ? 50 : 65)
                    .background(Color.white)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, isCompact ? 10 : 20)
            }
        }
    }
    
    struct CarbValueInputField: View {
        let title: String
        @Binding var text: String
        @Binding var isExplanationVisible: Bool
        let toggleAction: () -> Void
        let brandBlueColor: Color
        let isCompact: Bool
        
        var body: some View {
            HStack(spacing: 10) {
                InfoInputField(
                    title: title,
                    text: $text,
                    brandBlueColor: brandBlueColor,
                    isCompact: isCompact
                )
                
                Button(action: toggleAction) {
                    Image(systemName: "questionmark.circle.fill")
                        .foregroundColor(brandBlueColor)
                        .font(isCompact ? .title3 : .title2)
                }
            }
        }
    }
}

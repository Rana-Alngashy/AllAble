//
//  Untitled.swift
//  AllAble
//
//  Created by NORAH on 11/06/1447 AH.
//
//
//
//  AccountPage.swift
//  AllAble
//

import SwiftUI

struct AccountPage: View {
    @Environment(\.dismiss) private var dismiss
    
    // البيانات الشخصية المخزنة
    @AppStorage("account.name") private var name: String = ""
    @AppStorage("account.age") private var age: String = ""
    @AppStorage("account.guardianNumber") private var guardianNumber: String = ""
    @AppStorage("account.carbonValue") private var carbonValue: String = ""
    
    // 🔥 الصورة المختارة المخزنة (لضمان ظهورها) 🔥
    @AppStorage("selectedAvatarImageName") private var selectedAvatarImageName: String = "AvatarGirl"
    
    @State private var showMainOverlay = false
    
    let paleYellow = Color(red: 0.98, green: 0.96, blue: 0.90)
    let primaryColor = Color(red: 0.99, green: 0.85, blue: 0.33)
    
    @Environment(\.horizontalSizeClass) private var hSize
    private var isCompact: Bool { hSize == .compact }   // iPhone
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            paleYellow.ignoresSafeArea()
            
            VStack(spacing: isCompact ? 16 : 30) {
                
                // ————— HEADER & TITLE —————
                HStack {
                  
                    Spacer()
                    
                    Text("Toolbar.Account") // يعرض "Account" أو "الحساب"
                        .font(isCompact ? .title2 : .largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.gray.opacity(0.9))
                }
                .padding(.horizontal, isCompact ? 20 : 40)
                .padding(.top, 10)
                
                // 🔥 عرض صورة الأفاتار 🔥
                avatarSection
                
                // ————— INPUT FIELDS —————
                ScrollView {
                    VStack(spacing: isCompact ? 16 : 24) {
                        
                        InputField(label: "Account.Name", text: $name)
                        InputField(label: "Account.Age", text: $age)
                            .keyboardType(.numberPad)
                        InputField(label: "Account.GuardianNumber", text: $guardianNumber)
                            .keyboardType(.numberPad)
                        InputField(label: "Account.CarbonValue", text: $carbonValue)
                            .keyboardType(.decimalPad)
                    }
                    .padding(.horizontal, isCompact ? 20 : 40)
                    .padding(.top, 10)
                }
                
                // ————— SAVE BUTTON —————
                Button(action: {
                    dismiss()
                }) {
                    Text("Button.Save") // يعرض "Save" أو "حفظ"
                        .font(isCompact ? .title3 : .title2)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .frame(height: isCompact ? 50 : 65)
                        .background(primaryColor)
                        .foregroundColor(.black)
                        .cornerRadius(15)
                }
                .padding(.horizontal, isCompact ? 20 : 40)
                .padding(.bottom, isCompact ? 20 : 40)
            }
            .environment(\.layoutDirection, .rightToLeft) // لضمان RTL
        }
    }
    
    // MARK: - Avatar Section Helper
    
    private var avatarSection: some View {
        ZStack {
            // خلفية بيضاء دائرية أو مستطيلة
            RoundedRectangle(cornerRadius: 28)
                .fill(Color.white)
                .frame(
                    width: isCompact ? 200 : 350,
                    height: isCompact ? 200 : 350
                )
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)

            // 🔥 عرض الأفاتار باستخدام الاسم المخزن 🔥
            Image(selectedAvatarImageName)
                .resizable()
                .scaledToFit()
                .frame(
                    width: isCompact ? 180 : 320,
                    height: isCompact ? 180 : 320
                )
        }
        .padding(.top, isCompact ? 10 : 30)
    }
    
    // MARK: - Input Field Struct (معرّب ومحاذى لليمين)
    
    struct InputField: View {
        let label: String
        @Binding var text: String
        
        var body: some View {
            // محاذاة لليمين لتناسب RTL
            VStack(alignment: .trailing, spacing: 8) {
                // استخدام LocalizedStringKey لعرض النص المعرب فقط (مثل "Name")
                Text(LocalizedStringKey(label))
                    .font(.body.bold())
                    .foregroundColor(.black.opacity(0.9))
                    .frame(maxWidth: .infinity, alignment: .trailing)

                TextField("", text: $text)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 12)
                    .background(Color.white)
                    .cornerRadius(14)
                    .shadow(color: .gray.opacity(0.2), radius: 3, x: 0, y: 2)
                    .multilineTextAlignment(.trailing) // محاذاة النص المدخل لليمين
            }
        }
    }
}

// معاينة الكود
#Preview {
    NavigationStack {
        AccountPage()
    }
}





//import SwiftUI
//
//struct AccountPage: View {
//    @Environment(\.dismiss) private var dismiss
//
//    @AppStorage("account.name") private var name: String = ""
//    @AppStorage("account.age") private var age: String = ""
//    @AppStorage("account.guardianNumber") private var guardianNumber: String = ""
//    @AppStorage("account.carbonValue") private var carbonValue: String = ""
//
//    // بديل تنقل داخلي بانتقال مخصص من اليسار
//    @State private var showMainOverlay = false
//
//    let paleYellow = Color(red: 0.98, green: 0.96, blue: 0.90)
//
//    // مكون مخصص لحقل الإدخال
//    struct InputField: View {
//        let label: String
//        @Binding var text: String
//
//        var body: some View {
//            VStack(alignment: .trailing, spacing: 12) {
//                Text(label)
//                    .font(.custom("Arial", size: 17))
//                    .foregroundColor(.black.opacity(0.9))
//                    .frame(maxWidth: .infinity, alignment: .trailing)
//
//                TextField("", text: $text)
//                    .padding(.vertical, 10)
//                    .padding(.horizontal, 10)
//                    .background(Color.white)
//                    .cornerRadius(15)
//                    .shadow(color: .gray.opacity(0.2), radius: 1, x: 0, y: 1)
//                    .multilineTextAlignment(.trailing)
//            }
//        }
//    }
//
//    // جسم الشاشة الرئيسية
//    var body: some View {
//        ZStack {
//            Color.black.edgesIgnoringSafeArea(.all)
//
//            VStack(spacing: 0) {
//                // صورة الملف الشخصي (الأفاتار) مع خلفية بيضاوية بالطول
//                ZStack {
//                    Ellipse()
//                        .fill(Color.white)
//                        .frame(width: 230, height: 260) // أضيق بالعرض وأطول بالطول
//                        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
//
//                    Image("profile_avatar")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 200, height: 200)
//                }
//                .padding(.top, 5)
//
//                // حقول إدخال البيانات
//                GeometryReader { geometry in
//                    VStack(spacing: 35) {
//                        InputField(label: "Name", text: $name)
//                        InputField(label: "Age", text: $age)
//                        InputField(label: "Guardian Number", text: $guardianNumber)
//                        InputField(label: "Carbon Value", text: $carbonValue)
//                    }
//                    .frame(width: geometry.size.width * 0.75)
//                    .padding(.top, 60)
//                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
//                }
//                .frame(height: 350)
//
//                Button(action: {
//                    // حاول الرجوع إن كانت داخل NavigationStack
//                    dismiss()
//
//                    // ثم فعّل الانتقال المخصص كحل موحّد لضمان الحركة لليسار
//                    withAnimation(.easeInOut(duration: 0.35)) {
//                        showMainOverlay = true
//                    }
//                }) {
//                    Text("Save")
//                        .font(.headline)
//                        .padding(.horizontal, 30)
//                        .padding(.vertical, 10)
//                        .background(Color(#colorLiteral(red: 0.99, green: 0.85, blue: 0.33, alpha: 1)))
//                        .foregroundColor(.black)
//                        .cornerRadius(15)
//                }
//                .padding(.top, 100)
//
//                Spacer()
//            }
//            .background(paleYellow)
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//
//            // طبقة انتقال مخصص لعرض MainPage من اليسار
//            if showMainOverlay {
//                MainPage()
//                    .transition(.move(edge: .leading)) // دخول من جهة اليسار
//                    .zIndex(1)
//            }
//        }
//        .environment(\.layoutDirection, .rightToLeft)
//    }
//}
//
//// معاينة الكود
//struct AccountPage_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            AccountPage()
//        }
//    }
//}

//
//  Untitled.swift
//  AllAble
//
//  Created by NORAH on 11/06/1447 AH.
//

import SwiftUI

struct AccountPage: View {
    @Environment(\.dismiss) private var dismiss

    @AppStorage("account.name") private var name: String = ""
    @AppStorage("account.age") private var age: String = ""
    @AppStorage("account.guardianNumber") private var guardianNumber: String = ""
    @AppStorage("account.carbonValue") private var carbonValue: String = ""

    // بديل تنقل داخلي بانتقال مخصص من اليسار
    @State private var showMainOverlay = false

    let paleYellow = Color(red: 0.98, green: 0.96, blue: 0.90)

    // مكون مخصص لحقل الإدخال
    struct InputField: View {
        let label: String
        @Binding var text: String

        var body: some View {
            VStack(alignment: .trailing, spacing: 12) {
                Text(label)
                    .font(.custom("Arial", size: 17))
                    .foregroundColor(.black.opacity(0.9))
                    .frame(maxWidth: .infinity, alignment: .trailing)

                TextField("", text: $text)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: .gray.opacity(0.2), radius: 1, x: 0, y: 1)
                    .multilineTextAlignment(.trailing)
            }
        }
    }

    // جسم الشاشة الرئيسية
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                // صورة الملف الشخصي (الأفاتار) مع خلفية بيضاوية بالطول
                ZStack {
                    Ellipse()
                        .fill(Color.white)
                        .frame(width: 230, height: 260) // أضيق بالعرض وأطول بالطول
                        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)

                    Image("profile_avatar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                }
                .padding(.top, 5)

                // حقول إدخال البيانات
                GeometryReader { geometry in
                    VStack(spacing: 35) {
                        InputField(label: "Name", text: $name)
                        InputField(label: "Age", text: $age)
                        InputField(label: "Guardian Number", text: $guardianNumber)
                        InputField(label: "Carbon Value", text: $carbonValue)
                    }
                    .frame(width: geometry.size.width * 0.75)
                    .padding(.top, 60)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
                .frame(height: 350)

                Button(action: {
                    // حاول الرجوع إن كانت داخل NavigationStack
                    dismiss()

                    // ثم فعّل الانتقال المخصص كحل موحّد لضمان الحركة لليسار
                    withAnimation(.easeInOut(duration: 0.35)) {
                        showMainOverlay = true
                    }
                }) {
                    Text("Save")
                        .font(.headline)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(15)
                }
                .padding(.top, 100)

                Spacer()
            }
            .background(paleYellow)
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // طبقة انتقال مخصص لعرض MainPage من اليسار
            if showMainOverlay {
                MainPage()
                    .transition(.move(edge: .leading)) // دخول من جهة اليسار
                    .zIndex(1)
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}

// معاينة الكود
struct AccountPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AccountPage()
        }
    }
}

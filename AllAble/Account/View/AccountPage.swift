//
//  Untitled.swift
//  AllAble
//
//  Created by NORAH on 11/06/1447 AH.
//

import SwiftUI

struct AccountPage: View {
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var guardianNumber: String = ""
    @State private var carbonValue: String = ""

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
                    .cornerRadius(5)
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
                // شريط التنقل المعدل والمصحح
                HStack(alignment: .top) {
                    // 1. عنوان "Account" في اليمين (Leading في وضع RTL)
                    Text("Account")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding([.leading], 25) // مسافة من اليمين (leading)
                    
                    Spacer()

                    // 2. الزر المثلث في اليسار (Trailing في وضع RTL)
                    Image(systemName: "triangle.fill")
                        .resizable()
                        // *التصحيح:* حجم المثلث في الصورة الأصلية أصغر
                        .frame(width: 25, height: 25)
                        // *التصحيح:* الدوران الصحيح لجعله يشير لليسار
                        .rotationEffect(.degrees(-90))
                        .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.2))
                        .padding([.trailing], 25) // مسافة من اليسار (trailing)
                }
                .padding(.top, 20)
                .padding(.bottom, 30)
                .frame(maxWidth: .infinity)
                // ----------------------------------------------------------------

                // صورة الملف الشخصي (الأفاتار)
                Image("profile_avatar")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    // *التصحيح:* تقليل حجم الأفاتار قليلاً ليتناسب مع التباعد
                    .frame(width: 140, height: 140)
                    .padding(.top, 5)

                // حقول إدخال البيانات
                GeometryReader { geometry in
                    VStack(spacing: 35) {
                        InputField(label: "الاسم", text: $name)
                        InputField(label: "العمر", text: $age)
                        InputField(label: "رقم ولي الامر", text: $guardianNumber)
                        InputField(label: "قيمة الكارب", text: $carbonValue)
                    }
                    .frame(width: geometry.size.width * 0.75)
                    .padding(.top, 60)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
                .frame(height: 350)

                Spacer()
            }
            .background(paleYellow)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}

// معاينة الكود
struct AccountPage_Previews: PreviewProvider {
    static var previews: some View {
        AccountPage()
    }
}

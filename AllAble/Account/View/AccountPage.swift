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
    @AppStorage("Account.Name") private var name: String = ""
    @AppStorage("Account.Age") private var age: String = ""
    @AppStorage("Account.GuardianNumber") private var guardianNumber: String = ""
    @AppStorage("Account.CarbValue") private var carbValue: String = ""
    
    // 🔥 الصورة المختارة المخزنة (لضمان ظهورها) 🔥
    @AppStorage("selectedAvatarImageName") private var selectedAvatarImageName: String = "AvatarGirl"
    
    @State private var showMainOverlay = false
    
    let paleYellow = Color(red: 0.98, green: 0.96, blue: 0.90)
    let primaryColor = Color(red: 0.99, green: 0.85, blue: 0.33)
    
    @Environment(\.horizontalSizeClass) private var hSize
    private var isCompact: Bool { true}  
    // MARK: - Body
    
    var body: some View {
        ZStack {
            paleYellow.ignoresSafeArea()
            
            VStack(spacing: isCompact ? 16 : 30) {
                
                // ————— HEADER & TITLE —————
                HStack {
                  
                    
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
                        InputField(label: "Account.CarbValue", text: $carbValue)
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
        }.onAppear {
            name = UserDefaults.standard.string(forKey: "Account.Name") ?? ""
            age = UserDefaults.standard.string(forKey: "Account.Age") ?? ""
            guardianNumber = UserDefaults.standard.string(forKey: "Account.GuardianNumber") ?? ""
            carbValue = UserDefaults.standard.string(forKey: "Account.CarbValue") ?? ""

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
            VStack(alignment: .leading, spacing: 8) {

                // LABEL → LTR LEFT
                Text(LocalizedStringKey(label))
                    .font(.body.bold())
                    .foregroundColor(.black.opacity(0.9))
                    .frame(maxWidth: .infinity, alignment: .leading)

                // TEXTFIELD → LTR LEFT
                TextField("", text: $text)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 12)
                    .background(Color.white)
                    .cornerRadius(14)
                    .shadow(color: .gray.opacity(0.2), radius: 3, x: 0, y: 2)
                    .multilineTextAlignment(.leading)
            }
        }
    }

}

#Preview {
    NavigationStack {
        AccountPage()
            .toolbarTitleDisplayMode(.inline)
            .environment(\.layoutDirection, .leftToRight)   // 👈 إجبار اليسار
    }
}

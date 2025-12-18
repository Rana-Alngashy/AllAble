//
//
//  InfoView.swift
//  AllAble
//
//  Created by Wteen Alghamdy on 15/06/1447 AH.
//
//
import SwiftUI

struct InfoView: View {
    @StateObject var viewModel = InfoViewModel()
    let selectedAvatar: Avatar

    let backgroundColor = Color(red: 0.97, green: 0.96, blue: 0.92)
    let brandBlueColor = Color(red: 0.1, green: 0.3, blue: 0.5)
    let primaryColor = Color(red: 0.99, green: 0.85, blue: 0.33)
    @EnvironmentObject var router: NotificationRouter
    @EnvironmentObject var historyStore: HistoryStore
    @EnvironmentObject var carbRatioStore: CarbRatioStore // ✅ متاح

    @Environment(\.horizontalSizeClass) private var hSize
    private var isCompact: Bool { hSize == .compact }   // iPhone
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: isCompact ? 24 : 60) {
                    
                    Spacer().frame(height: isCompact ? 20 : 200)
                    
                   
                        // 📱 iPhone: عمودي
                        VStack(spacing: 30) {
                            avatarSection
                            formSection
                        }
                        .padding(.horizontal, 20)
                }
            }
        }
//        .environment(\.layoutDirection, .rightToLeft)
        .fullScreenCover(isPresented: $viewModel.shouldNavigateToCarbRatio) { // ✅ الانتقال إلى CarbRatioPage
            // ✅ الانتقال مباشرة إلى CarbRatioPage في وضع Onboarding
            CarbRatioPage(store: carbRatioStore, isFirstTimeOnboarding: true)
                .environmentObject(router)
                .environmentObject(historyStore)
                .environmentObject(carbRatioStore)
        }

        .toolbarTitleDisplayMode(.inline) }
    
    // MARK: - Sub Views
    
    private var avatarSection: some View {
        VStack {
            ZStack {

                Circle()
                    .fill(Color.white)
                    .frame(width: isCompact ? 200 : 350, height: isCompact ? 200 : 350)
                    .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)

                // 🔥 عرض الأفاتار باستخدام الاسم المخزن 🔥
                Image(selectedAvatar .imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: isCompact ? 180 : 320,
                        height: isCompact ? 180 : 320
                    )
            }
                
            // Title
            Text("Title.UserInfo")
                .font(isCompact ? .title2 : .largeTitle)
                .bold()
                .foregroundColor(.black)
                .padding(.top, isCompact ? 10 : 20)
        }
    }
    
    private var formSection: some View {
        VStack(spacing: 20) {
            // حقل الاسم
            InfoInputField(
                title: NSLocalizedString("Account.Name", comment: ""),
                text: $viewModel.name,
                brandBlueColor: brandBlueColor,
                isCompact: isCompact
            )

            // حقل العمر
            InfoInputField(
                title: NSLocalizedString("Account.Age", comment: ""),
                text: $viewModel.age,
                brandBlueColor: brandBlueColor,
                isCompact: isCompact
            )
            .keyboardType(.numberPad)
            
            // ————— NEXT BUTTON —————
            Button(action: viewModel.handleNext) {
                Text("Button.Next")
                    .font(isCompact ? .body : .title3)
                    .bold()
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: isCompact ? 56 : 85)
                    .background(viewModel.isNextButtonEnabled ? primaryColor : Color.gray.opacity(0.3))
                    .cornerRadius(16)
            }
            .disabled(!viewModel.isNextButtonEnabled)
            .padding(.top, isCompact ? 10 : 30)
        }
        .padding(.horizontal, isCompact ? 0 : 40)
        .padding(.bottom, isCompact ? 40 : 80)
    }
    
    
    // MARK: - Helper Structs
    
    struct InfoInputField: View {
        let title: String
        @Binding var text: String
        let brandBlueColor: Color
        let isCompact: Bool
        
        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.callout.bold())
                    .foregroundColor(brandBlueColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("", text: $text)
                    .font(.body)
                    .foregroundColor(.black)
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .multilineTextAlignment(.leading)
                    .frame(minHeight: 50)
            }
        }
    }
}
// MARK: - Preview
#Preview {
    // 1. تحديد Avatar وهمي (يجب أن يكون اسم الصورة موجوداً لديك)
    let mockAvatar = Avatar(name: "Mock Girl", imageName: "AvatarGirl")
    
    // 2. تغليف العرض بـ NavigationStack لدعم الـ toolbar
    NavigationStack {
        InfoView(selectedAvatar: mockAvatar)
            // 3. توفير كائنات البيئة المطلوبة
            .environmentObject(NotificationRouter())
            .environmentObject(HistoryStore())
            .environmentObject(CarbRatioStore())   // توفير المخزن
//            .environment(\.layoutDirection, .rightToLeft) // إذا كان التطبيق يعتمد على RTL
    }
}

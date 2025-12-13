import SwiftUI

struct MainPage: View {
    
    
    @EnvironmentObject var router: NotificationRouter
    @EnvironmentObject var historyStore: HistoryStore
    @EnvironmentObject var carbRatioStore: CarbRatioStore
    
    @AppStorage("selectedAvatarImageName") private var selectedAvatarImageName: String = ""
    @AppStorage("Account.Name") private var userName: String = "Sarah"
    
    @Environment(\.horizontalSizeClass) private var hSize
    @StateObject private var viewModel = MainPageViewModel()
    
    private var isCompact: Bool { true}
    
    // ✅ نص آخر جرعة فعلية من السجل
    private var lastDoseDisplayText: String {
        if let last = historyStore.entries.last {
            // مثال: "6 for Lunch"
            let doseText: String
            if last.insulinDose.rounded() == last.insulinDose {
                doseText = String(format: "%.0f", last.insulinDose)
            } else {
                doseText = String(format: "%.1f", last.insulinDose)
            }
            // استخدم اسم الوجبة أو نوعها
            let mealText = last.mealName.isEmpty ? last.mealTypeTitle : last.mealName
            return "\(doseText) for \(mealText)"
        } else {
            return NSLocalizedString("LastDose.NoDose", comment: "")
        }
    }
    
    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            ZStack {
                Color(#colorLiteral(red: 0.98, green: 0.96, blue: 0.90, alpha: 1))
                    .ignoresSafeArea()
                
                VStack(spacing: isCompact ? 30 : 50) {
                    
                    headerSection // الآن فقط الأزرار الجانبية
                    
                    Spacer()
                    
                    // ✅ البطاقة الكبيرة لآخر جرعة (التصميم القديم)
                    mainInfoCard
                        .padding(.horizontal, isCompact ? 20 : 50)
                    
                    Spacer()

                    
                    avatarSection
                    
                    actionButtons
                        .padding(.horizontal, isCompact ? 20 : 50)
                        .padding(.bottom, isCompact ? 40 : 80)
                }
            }
            .navigationBarHidden(true)
            .environment(\.layoutDirection, .leftToRight)
        }
        // 👇 إضافة وجهة التنقل إلى صفحة Carb Ratio (كـ fullScreenCover)
        .fullScreenCover(isPresented: $viewModel.shouldNavigateToCarbRatio) {
            CarbRatioPage(store: carbRatioStore, isFirstTimeOnboarding: false)
                .environmentObject(carbRatioStore)
        }
        .navigationDestination(for: String.self) { destination in
            if destination == "AddMeal" {
                 AddMealView()
            } else if destination == "History" {
                 HistoryView(viewModel: HistoryViewModel(store: historyStore))
            } else if destination == "Account" {
                 AccountPage()
            }
        }
        
    }
    
    // MARK: - 1. Header (معدل لاستقبال Carb Ratio وزر الحساب فقط)
    private var headerSection: some View {
        let customYellow = Color(#colorLiteral(red: 0.99, green: 0.85, blue: 0.33, alpha: 1))
        return HStack {
            // 🆕 زر إعدادات نسب الكارب (أعلى اليسار)
            Button(action: { viewModel.shouldNavigateToCarbRatio = true }) {
                Image(systemName: "slider.horizontal.3")
                    .font(.title)
                    .foregroundColor(customYellow)
                    .frame(width: 44, height: 44)
            }
            .padding(.leading, isCompact ? 10 : 30)

            Spacer()
            
            // زر صفحة الحساب (أعلى اليمين)
            NavigationLink {
                AccountPage()
            } label: {
                Image(systemName: "person.circle.fill")
                    .font(.title)
                    .foregroundColor(customYellow)
                    .frame(width: 44, height: 44)
            }
            .padding(.trailing, isCompact ? 10 : 30)
        }
        .padding(.top, isCompact ? 10 : 30)
    }

    // MARK: - 2. البطاقة البيضاء الكبيرة (mainInfoCard)
    private var mainInfoCard: some View {
        VStack(spacing: 14) {
            Text("LastDose.Title")
                .font(.headline)
                .foregroundColor(.gray)
            
            // ✅ عرض آخر جرعة فعلية من HistoryStore
            Text(lastDoseDisplayText)
                .font(isCompact ? .largeTitle : .system(.largeTitle, weight: .heavy))
                .foregroundColor(Color(#colorLiteral(red: 0.12, green: 0.18, blue: 0.45, alpha: 1)))
                .minimumScaleFactor(0.6)
                .lineLimit(1)
        }
        .padding(.vertical, isCompact ? 25 : 24)
        .padding(.horizontal, 20)
        .frame(maxWidth: isCompact ? .infinity : 520)
        .background(Color.white)
        .cornerRadius(28)
        .shadow(color: .black.opacity(0.07), radius: 8, y: 4)
    }
    
    
    
    private var actionButtons: some View {
        VStack(spacing: isCompact ? 16 : 30) {
            // زر حساب وجبتي
            NavigationLink(destination: AddMealView()) {
                Text("Title.CalculateMeal")
                    .font(isCompact ? .title2 : .largeTitle)
                    .bold()
                    .foregroundColor(.black)
                    .frame(maxWidth: isCompact ? .infinity : 520)
                    .frame(height: isCompact ? 70 : 100)
                    .background(Color(#colorLiteral(red: 0.99, green: 0.85, blue: 0.33, alpha: 1)))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.15), radius: 5, y: 3)
            }
            
            // زر وجباتي السابقة
            NavigationLink {
                HistoryView(
                    viewModel: HistoryViewModel(store: historyStore)
                )
            } label: {
                Text("Button.MyMeals")
                    .font(isCompact ? .body : .title3)
                    .foregroundColor(.black)
                    .frame(maxWidth: isCompact ? .infinity : 520)
                    .frame(height: isCompact ? 56 : 85)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                Color(#colorLiteral(red: 0.99, green: 0.85, blue: 0.33, alpha: 1)),
                                lineWidth: 3
                            )
                    )
            }
        }
    }

    private var avatarSection: some View {
        VStack(spacing: 18) {
            Image(selectedAvatarImageName)
                .resizable()
                .scaledToFit()
                .frame(
                    width: isCompact ? 220 : 400,
                    height: isCompact ? 280 : 500
                )
                .background(.white)
                .cornerRadius(36)
                .shadow(color: .black.opacity(0.07), radius: 8, y: 4)
            
            Text(userName)
                .font(isCompact ? .headline : .title2)
                .foregroundColor(.black)
        }
    }
}
#Preview {
    MainPage()
        .environmentObject(NotificationRouter())
        .environmentObject(HistoryStore()) // ✅ للمعاينة
}


































//import SwiftUI
//
//struct MainPage: View {
//    
//    
//    @EnvironmentObject var router: NotificationRouter
//    @EnvironmentObject var historyStore: HistoryStore  // ✅ قراءة السجل من البيئة
//    
//    @AppStorage("selectedAvatarImageName") private var selectedAvatarImageName: String = ""
//    @AppStorage("Account.Name") private var userName: String = "Sarah"
//    
//    @Environment(\.horizontalSizeClass) private var hSize
//    @StateObject private var viewModel = MainPageViewModel()
//    
//    private var isCompact: Bool { true}  
//    // ✅ نص آخر جرعة فعلية من السجل
//    private var lastDoseDisplayText: String {
//        if let last = historyStore.entries.last {
//            // مثال: "6 for Lunch"
//            let doseText: String
//            if last.insulinDose.rounded() == last.insulinDose {
//                doseText = String(format: "%.0f", last.insulinDose)
//            } else {
//                doseText = String(format: "%.1f", last.insulinDose)
//            }
//            // استخدم اسم الوجبة أو نوعها
//            let mealText = last.mealName.isEmpty ? last.mealTypeTitle : last.mealName
//            return "\(doseText) for \(mealText)"
//        } else {
//            return NSLocalizedString("LastDose.NoDose", comment: "")
//        }
//    }
//    
//    var body: some View {
//        NavigationStack(path: $router.navigationPath) {
//            ZStack {
//                Color(#colorLiteral(red: 0.98, green: 0.96, blue: 0.90, alpha: 1))
//                    .ignoresSafeArea()
//                
//                VStack {
//                    
//                    // MARK: - Toolbar
//                    HStack {
//                        Spacer()
//                        NavigationLink(destination: AccountPage()) {
//                            Image(systemName: "person.circle.fill")
//                                .font(isCompact ? .title2 : .largeTitle) // ✅ Dynamic Type
//                                .foregroundColor(.yellow)
//                        }
//                    }
//                    .padding(.horizontal, isCompact ? 20 : 30)
//                    .padding(.top, isCompact ? 10 : 20)
//                    
//                    Spacer(minLength: isCompact ? 20 : 40)
//                    
//                    // MARK: - Main Layout (iPhone / iPad)
//                    if isCompact {
//                        // 📱 iPhone (عمودي)
//                        VStack(spacing: 24) {
//                            mainInfoCard
//                            calculateButton
//                            historyButton
//                            avatarSection
//                        }
//                        .padding(.horizontal, 20)
//                    } else {
//                        // 💻 iPad (أفقي)
//                        HStack(alignment: .center, spacing: 60) {
//                            VStack(spacing: 35) {
//                                mainInfoCard
//                                calculateButton
//                                historyButton
//                            }
//                            avatarSection
//                        }
//                        .padding(.horizontal, 50)
//                    }
//                    
//                    Spacer()
//                }
//            }
//            .navigationBarBackButtonHidden(true) // ← إخفاء زر الرجوع هنا
//            .navigationDestination(isPresented: $router.shouldNavigateToOptionView) {
//                OptionView()
//            }
//        }
//    }
//    
//    // MARK: - Components
//    
//    private var mainInfoCard: some View {
//        VStack(spacing: 14) {
//            Text("LastDose.Title")
//                .font(.headline)                      // ✅ Dynamic Type
//                .foregroundColor(.gray)
//            
//            // ✅ عرض آخر جرعة فعلية من HistoryStore
//            Text(lastDoseDisplayText)
//                .font(isCompact ? .largeTitle : .system(.largeTitle, weight: .heavy))
//                .foregroundColor(Color(#colorLiteral(red: 0.12, green: 0.18, blue: 0.45, alpha: 1)))
//                .minimumScaleFactor(0.6)
//                .lineLimit(1)
//        }
//        .padding(.vertical, isCompact ? 16 : 24)
//        .padding(.horizontal, 20)
//        .frame(maxWidth: isCompact ? .infinity : 520)
//        .background(Color.white)
//        .cornerRadius(28)
//        .shadow(color: .black.opacity(0.07), radius: 8, y: 4)
//    }
//    
//    private var calculateButton: some View {
//        NavigationLink(destination: AddMealView()) {
//            Text("Title.CalculateMeal")
//                .font(isCompact ? .headline : .title2)   // ✅ Dynamic Type
//                .foregroundColor(.black)
//                .frame(maxWidth: isCompact ? .infinity : 520)
//                .frame(height: isCompact ? 60 : 85)
//                .background(Color(#colorLiteral(red: 0.99, green: 0.85, blue: 0.33, alpha: 1)))
//                .cornerRadius(16)
//        }
//    }
//    
////    private var historyButton: some View {
////        NavigationLink(destination: HistoryView(viewModel: HistoryViewModel(store: HistoryStore()))) {
////            Text("Button.MyMeals")
////                .font(isCompact ? .body : .title3)   // ✅ Dynamic Type
////                .foregroundColor(.black)
////                .frame(maxWidth: isCompact ? .infinity : 520)
////                .frame(height: isCompact ? 56 : 85)
////                .overlay(
////                    RoundedRectangle(cornerRadius: 16)
////                        .stroke(Color(#colorLiteral(red: 0.99, green: 0.85, blue: 0.33, alpha: 1)), lineWidth: 3)
////                )
////        }
////    }
////
//    private var historyButton: some View {
//        NavigationLink {
//            HistoryView(
//                viewModel: HistoryViewModel(store: historyStore)  // ← هنا نستخدم المخزن المشترك
//            )
//        } label: {
//            Text("Button.MyMeals")
//                .font(isCompact ? .body : .title3)
//                .foregroundColor(.black)
//                .frame(maxWidth: isCompact ? .infinity : 520)
//                .frame(height: isCompact ? 56 : 85)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 16)
//                        .stroke(
//                            Color(#colorLiteral(red: 0.99, green: 0.85, blue: 0.33, alpha: 1)),
//                            lineWidth: 3
//                        )
//                )
//        }
//    }
//
//    private var avatarSection: some View {
//        VStack(spacing: 18) {
//            Image(selectedAvatarImageName)
//                .resizable()
//                .scaledToFit()
//                .frame(
//                    width: isCompact ? 220 : 400,
//                    height: isCompact ? 280 : 500
//                )
//                .background(.white)
//                .cornerRadius(36)
//                .shadow(color: .black.opacity(0.07), radius: 8, y: 4)
//            
//            Text(userName)
//                .font(isCompact ? .headline : .title2)  // ✅ Dynamic Type
//                .foregroundColor(.black)
//        }
//    }
//}
//
//#Preview {
//    MainPage()
//        .environmentObject(NotificationRouter())
//        .environmentObject(HistoryStore()) // ✅ للمعاينة
//}

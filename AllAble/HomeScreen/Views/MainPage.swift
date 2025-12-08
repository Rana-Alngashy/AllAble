import SwiftUI

struct MainPage: View {
    
    @EnvironmentObject var router: NotificationRouter
    @AppStorage("selectedAvatarImageName") private var selectedAvatarImageName: String = "AvatarGirl"
    @AppStorage("account.name") private var userName: String = "Sarah"
    
    @Environment(\.horizontalSizeClass) private var hSize
    @StateObject private var viewModel = MainPageViewModel()
    
    private var isCompact: Bool {
        hSize == .compact   // iPhone
    }
    
    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            ZStack {
                Color(#colorLiteral(red: 0.98, green: 0.96, blue: 0.90, alpha: 1))
                    .ignoresSafeArea()
                
                VStack {
                    
                    // MARK: - Toolbar
                    HStack {
                        Spacer()
                        NavigationLink(destination: AccountPage()) {
                            Image(systemName: "person.circle.fill")
                                .font(isCompact ? .title2 : .largeTitle) // ✅ Dynamic Type
                                .foregroundColor(.yellow)
                        }
                    }
                    .padding(.horizontal, isCompact ? 20 : 30)
                    .padding(.top, isCompact ? 10 : 20)
                    
                    Spacer(minLength: isCompact ? 20 : 40)
                    
                    // MARK: - Main Layout (iPhone / iPad)
                    if isCompact {
                        // 📱 iPhone (عمودي)
                        VStack(spacing: 24) {
                            mainInfoCard
                            calculateButton
                            historyButton
                            avatarSection
                        }
                        .padding(.horizontal, 20)
                    } else {
                        // 💻 iPad (أفقي)
                        HStack(alignment: .center, spacing: 60) {
                            VStack(spacing: 35) {
                                mainInfoCard
                                calculateButton
                                historyButton
                            }
                            avatarSection
                        }
                        .padding(.horizontal, 50)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden(true) // ← إخفاء زر الرجوع هنا
            .navigationDestination(isPresented: $router.shouldNavigateToOptionView) {
                OptionView()
            }
        }
    }
    
    // MARK: - Components
    
    private var mainInfoCard: some View {
        VStack(spacing: 14) {
            Text("Last insulin dose calculation")
                .font(.headline)                      // ✅ Dynamic Type
                .foregroundColor(.gray)
            
            Text("\(viewModel.lastDose) for \(viewModel.userName)")
                .font(isCompact ? .largeTitle : .system(.largeTitle, weight: .heavy)) // ✅
                .foregroundColor(Color(#colorLiteral(red: 0.12, green: 0.18, blue: 0.45, alpha: 1)))
                .minimumScaleFactor(0.6)
                .lineLimit(1)
        }
        .padding(.vertical, isCompact ? 16 : 24)
        .padding(.horizontal, 20)
        .frame(maxWidth: isCompact ? .infinity : 520)
        .background(Color.white)
        .cornerRadius(28)
        .shadow(color: .black.opacity(0.07), radius: 8, y: 4)
    }
    
    private var calculateButton: some View {
        NavigationLink(destination: AddMealView()) {
            Text("Calculate My Meal")
                .font(isCompact ? .headline : .title2)   // ✅ Dynamic Type
                .foregroundColor(.black)
                .frame(maxWidth: isCompact ? .infinity : 520)
                .frame(height: isCompact ? 60 : 85)
                .background(Color(#colorLiteral(red: 0.99, green: 0.85, blue: 0.33, alpha: 1)))
                .cornerRadius(16)
        }
    }
    
    private var historyButton: some View {
        NavigationLink(destination: HistoryView()) {
            Text("My Previous Meals")
                .font(isCompact ? .body : .title3)   // ✅ Dynamic Type
                .foregroundColor(.black)
                .frame(maxWidth: isCompact ? .infinity : 520)
                .frame(height: isCompact ? 56 : 85)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(#colorLiteral(red: 0.99, green: 0.85, blue: 0.33, alpha: 1)), lineWidth: 3)
                )
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
                .font(isCompact ? .headline : .title2)  // ✅ Dynamic Type
                .foregroundColor(.black)
        }
    }
}

#Preview {
    MainPage()
        .environmentObject(NotificationRouter())
}

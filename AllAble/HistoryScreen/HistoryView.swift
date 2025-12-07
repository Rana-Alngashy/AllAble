import SwiftUI

struct HistoryView: View {
    // استخدام HistoryStore لقراءة السجل فقط
    @EnvironmentObject var historyStore: HistoryStore
    
    // ألوان الخلفية العامة
    // جعل الخلفية مطابقة لصفحة MainPage: (0.98, 0.96, 0.90)
    private let pageBackground = Color(red: 0.98, green: 0.96, blue: 0.90)
    private let capsuleBackground = Color.white.opacity(0.95)
    
    var body: some View {
        ZStack {
            pageBackground.ignoresSafeArea()
            
            VStack(alignment: .trailing, spacing: 24) {
                
                // شريط علوي: سهم يسار + كبسولة أيقونات يمين
                HStack {
                    // سهم رجوع يسار (شكل ديكوري، بإمكانك تحويله لزر رجوع فعلي)
                    
                    
                  
                    
                    // كبسولة أيقونات يمين
                  
                   
                    
                    
                }
                .padding(.top, 10)
                
                // العنوان الكبير
                Text("Meals")
                    .font(.system(size: 64, weight: .heavy))
                    .foregroundColor(.gray.opacity(0.9))
                    .padding(.trailing, 40)
                
                // عرض التاريخ الحقيقي من HistoryStore (بدون بيانات افتراضية)
                if historyStore.entries.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "tray")
                            .font(.system(size: 50))
                            .foregroundColor(.gray.opacity(0.6))
                        Text("No items found in the log")
                            .foregroundColor(.gray)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 28) {
                            ForEach(historyStore.entries) { entry in
                                MealLargeCard(
                                    type: localizedType(entry.mealTypeTitle),
                                    name: entry.mealName,
                                    carbsText: "\(entry.totalCarbs)g",
                                    insulinText: formatDose(entry.insulinDose),
                                    // إجبار استخدام الصور الافتراضية حسب نوع الوجبة
                                    imageName: fallbackImageName(for: entry.mealTypeTitle),
                                    background: backgroundColor(for: entry.mealTypeTitle)
                                )
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 20)
                    }
                }
                
                Spacer(minLength: 0)
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
    
    // MARK: - Helpers
    
    private func localizedType(_ type: String) -> String {
        switch type.lowercased() {
        case "breakfast", "فطور": return "Breakfast"
        case "lunch", "غداء": return "Lunch"
        case "dinner", "عشاء": return "Dinner"
        case "snacks", "سناكس": return "Snacks"
        default: return type
        }
    }
    
    private func fallbackImageName(for type: String) -> String {
        switch type.lowercased() {
        case "breakfast", "فطور": return "egg"        // الفطور → egg
        case "lunch", "غداء": return "lunch"          // الغداء → lunch
        case "dinner", "عشاء": return "salad"         // العشاء → salad
        case "snacks", "سناكس": return "snacksImg"    // السناكس → snacksImg
        default: return "egg"
        }
    }
    
    private func backgroundColor(for type: String) -> Color {
        switch type.lowercased() {
        case "breakfast", "فطور":
            return Color(red: 1.00, green: 0.98, blue: 0.80) // أصفر فاتح
        case "lunch", "غداء":
            return Color(red: 0.90, green: 0.98, blue: 0.85) // أخضر فاتح
        case "dinner", "عشاء":
            return Color(red: 0.90, green: 0.98, blue: 0.95) // أزرق/أخضر فاتح
        case "snacks", "سناكس":
            return Color(#colorLiteral(red: 1.00, green: 0.90, blue: 0.95, alpha: 1)) // وردي مائل للبنفسجي (مطابق لـ AddMealView)
        default:
            return Color.white.opacity(0.9)
        }
    }
    
    private func formatDose(_ dose: Double) -> String {
        if dose.rounded() == dose {
            return String(format: "%.0f", dose)
        } else {
            return String(format: "%.1f", dose)
        }
    }
}

// بطاقة كبيرة مطابقة للتصميم
private struct MealLargeCard: View {
    let type: String
    let name: String
    let carbsText: String
    let insulinText: String
    let imageName: String
    let background: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 36)
                .fill(background)
                .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 6)
                .frame(height: 170)
                .overlay(
                    RoundedRectangle(cornerRadius: 36)
                        .stroke(Color.white.opacity(0.7), lineWidth: 3)
                        .blur(radius: 0.5)
                )
            
            HStack(spacing: 18) {
                Spacer()
                
                // صورة الوجبة يمين
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.trailing, 16)
                
                // النصوص في المنتصف
                VStack(alignment: .trailing, spacing: 6) {
                    Text(type)
                        .font(.system(size: 44, weight: .heavy))
                        .foregroundColor(.gray.opacity(0.9))
                    
                    VStack(alignment: .trailing, spacing: 6) {
                        Text("Name of the meal: \(name)")
                        Text("Carb: \(carbsText)")
                        Text("insulin dose: \(insulinText)")
                    }
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(.black.opacity(0.7))
                }
                .padding(.trailing, 40)
                
                Spacer(minLength: 60)
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .environmentObject(HistoryStore()) // للمعاينة
            .previewLayout(.fixed(width: 1366, height: 1024))
    }
}

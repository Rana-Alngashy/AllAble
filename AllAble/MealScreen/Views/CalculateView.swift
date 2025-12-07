//
//  CalculateView.swift
//  AllAble
//
//  Created by Rana Alngashy on 12/06/1447 AH.
//
import SwiftUI

struct CalculateView: View {
    @EnvironmentObject var router: NotificationRouter
    
    // 1. Connect to the History Store
    @EnvironmentObject var historyStore: HistoryStore
    
    @AppStorage("account.carbonValue") private var storedCarbRatio: String = "15"
    
    // MARK: - Properties
    let totalCarbs: Int
    // 2. Add properties to receive the name and type
    let mealName: String
    let mealType: String
    
    @State private var navigateToOptionView = false
    
    let circleMaxSize: CGFloat = 300
    let customBackground = Color(red: 0.97, green: 0.96, blue: 0.92)
    
    var carbRatio: Double {
        return Double(storedCarbRatio) ?? 15.0
    }
    
    var insulinDose: Double {
        guard totalCarbs > 0 && carbRatio > 0 else { return 0.0 }
        let calculatedValue = Double(totalCarbs) / carbRatio
        return round(calculatedValue)
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack(spacing: 30) {
                    
                    Text("Your Insulin Dose")
                        .font(.system(size: 34, weight: .bold))
                        .padding(.top, 40)
                    
                    // ————— DETAILS BAR —————
                    HStack(spacing: 20) {
                        InfoCard(title: "Total Carbs", value: "\(totalCarbs)g", icon: "fork.knife")
                        InfoCard(title: "Carb Ratio", value: "1 : \(Int(carbRatio))", icon: "drop.fill")
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    // ————— CIRCLE DISPLAY —————
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 1.0, green: 0.85, blue: 0.9),
                                        Color(red: 0.95, green: 0.65, blue: 0.75)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: min(geometry.size.width * 0.5, circleMaxSize),
                                   height: min(geometry.size.width * 0.5, circleMaxSize))
                            .shadow(radius: 5)

                        Text(String(format: "%.0f", insulinDose))
                            .font(.system(size: 100, weight: .heavy))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    // ————— CONTINUE BUTTON (SAVE ACTION) —————
                    Button(action: {
                        // 3. Save the meal to history before continuing!
                        let newEntry = HistoryEntry(
                            mealTypeTitle: mealType,
                            mealName: mealName.isEmpty ? "My Meal" : mealName, // Default name if empty
                            totalCarbs: Double(totalCarbs),
                            insulinDose: insulinDose
                        )
                        historyStore.addEntry(newEntry)
                        
                        // Navigate
                        navigateToOptionView = true
                    }) {
                        Text("Continue")
                            .font(.title3.bold())
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color.white)
                            .cornerRadius(14)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, 50)
                    .padding(.bottom, 50)

                }
                .frame(maxWidth: 600)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(customBackground.ignoresSafeArea())
            .navigationDestination(isPresented: $navigateToOptionView) {
                OptionView()
            }
        }
    }
}

// Helper view
struct InfoCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(Color(red: 0.99, green: 0.85, blue: 0.33))
            
            VStack(alignment: .leading) {
                Text(title).font(.caption).foregroundColor(.gray)
                Text(value).font(.title3).bold().foregroundColor(.black)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}
//hi

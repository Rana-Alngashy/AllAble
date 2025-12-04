//
//  CalculateView.swift
//  AllAble
//
//  Created by Rana Alngashy on 12/06/1447 AH.
//
import SwiftUI

struct CalculateView: View {
    @EnvironmentObject var router: NotificationRouter
    
    // 1. Fetch the stored Carb Ratio directly from UserDefaults (set in AccountPage)
    // If empty or invalid, it defaults to "15"
    @AppStorage("account.carbonValue") private var storedCarbRatio: String = "15"
    
    // MARK: - Properties
    let totalCarbs: Int
    
    @State private var navigateToOptionView = false
    
    // Define the custom colors
    let customYellow = Color(red: 0.99, green: 0.85, blue: 0.33)
    let customBackground = Color(red: 0.97, green: 0.96, blue: 0.92)
    let circleMaxSize: CGFloat = 300
    
    // Helper to convert the stored string to a Double safely
    var carbRatio: Double {
        return Double(storedCarbRatio) ?? 15.0
    }
    
    // MARK: - Calculated Dose Logic
    var insulinDose: Double {
        guard totalCarbs > 0 && carbRatio > 0 else { return 0.0 }
        
        // 1. Calculate raw value
        let calculatedValue = Double(totalCarbs) / carbRatio
        
        // 2. Standard Rounding Rule:
        // round() rounds to the nearest integer (3.4 -> 3.0, 3.5 -> 4.0)
        return round(calculatedValue)
    }

    // MARK: - Body
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack {
                
                VStack(spacing: 30) {
                    
                    Text("Your Insulin Dose")
                        .font(.system(size: 34, weight: .bold))
                        .padding(.top, 40)
                    
                    // ————— DETAILS BAR (Input & Output) —————
                    // Displays the Total Carbs and the Ratio used
                    HStack(spacing: 20) {
                        // Card 1: Total Carbs
                        InfoCard(
                            title: "Total Carbs",
                            value: "\(totalCarbs)g",
                            icon: "fork.knife"
                        )
                        
                        // Card 2: Carb Ratio
                        InfoCard(
                            title: "Carb Ratio",
                            value: "1 : \(Int(carbRatio))",
                            icon: "drop.fill"
                        )
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    // ————— CIRCLE DISPLAY (Output) —————
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

                        // Format as whole number (precision 0)
                        Text(String(format: "%.0f", insulinDose))
                            .font(.system(size: 100, weight: .heavy))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    // ————— CONTINUE BUTTON —————
                    Button(action: {
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

// MARK: - Helper View for Details Bar
struct InfoCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(Color(red: 0.99, green: 0.85, blue: 0.33)) // Custom Yellow
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.title3)
                    .bold()
                    .foregroundColor(.black)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}

#Preview {
    CalculateView(totalCarbs: 52) // Example: 52 / 15 = 3.46 -> Rounds to 3
        .environmentObject(NotificationRouter())
}

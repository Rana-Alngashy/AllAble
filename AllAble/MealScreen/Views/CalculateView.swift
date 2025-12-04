//
//  CalculateView.swift
//  AllAble
//
//  Created by Rana Alngashy on 12/06/1447 AH.
//
//
//  CalculateView.swift
//  AllAble
//
//  Created by Rana Alngashy on 12/06/1447 AH.
//
//
//  CalculateView.swift
//  AllAble
//
//  Created by Rana Alngashy on 12/06/1447 AH.
//
import SwiftUI

struct CalculateView: View {
    @EnvironmentObject var router: NotificationRouter
    
    // 1. Inject AppFlow to get the Carb Ratio
    @EnvironmentObject var appFlow: AppFlowViewModel
    
    let totalCarbs: Int
    @State private var navigateToOptionView = false
    
    let customYellow = Color(red: 0.99, green: 0.85, blue: 0.33)
    let customBackground = Color(red: 0.97, green: 0.96, blue: 0.92)
    let circleMaxSize: CGFloat = 300
    
    // MARK: - Calculated Dose
    var insulinDose: Double {
        // Use the real ratio from the profile
        // If the ratio is 0 (error), default to 15 to avoid division by zero
        let ratio = appFlow.childProfile.carbRatio > 0 ? appFlow.childProfile.carbRatio : 15.0
        
        guard totalCarbs > 0 else { return 0.0 }
        
        let calculatedValue = Double(totalCarbs) / ratio
        
        // UPDATED LOGIC: Round to the nearest whole number
        // 3.4 rounds to 3.0
        // 3.5 rounds to 4.0
        return calculatedValue.rounded()
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack(spacing: 40) {
                    
                    Text("Your Insulin Dose")
                        .font(.system(size: 34, weight: .bold))
                        .padding(.top, 40)
                    
                    // Optional: Debugging text
                    // Text("Carbs: \(totalCarbs) / Ratio: \(Int(appFlow.childProfile.carbRatio))")
                    //    .font(.caption)
                    //    .foregroundColor(.gray)

                    Spacer()
                    
                    // ————— CIRCLE DISPLAY (Insulin Value) —————
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

                        // Format to show no decimal places since we are rounding to whole numbers
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
                .frame(maxWidth: 500)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(customBackground.ignoresSafeArea())
            
            .navigationDestination(isPresented: $navigateToOptionView) {
                OptionView()
            }
        }
    }
}

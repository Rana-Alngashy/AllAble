//
//  CalculateView.swift
//  AllAble
//
//  Created by Rana Alngashy on 12/06/1447 AH.
//
import SwiftUI

struct CalculateView: View {
    @EnvironmentObject var router: NotificationRouter
    
    // MARK: - Environment
    // Removed @Environment(\.dismiss) var dismiss as it's no longer needed for the back button
    
    // MARK: - Properties
    let totalCarbs: Int
    let carbConstant: Double = 15.0
    
    @State private var navigateToOptionView = false
    
    // Define the custom colors using fixed syntax
    let customYellow = Color(red: 0.99, green: 0.85, blue: 0.33)
    let customBackground = Color(red: 0.97, green: 0.96, blue: 0.92)
    let circleMaxSize: CGFloat = 300
    
    // MARK: - Calculated Dose
    var insulinDose: Double {
        guard totalCarbs > 0 && carbConstant > 0 else { return 0.0 }
        let calculatedValue = Double(totalCarbs) / carbConstant
        let roundedToNearestHalf = round(calculatedValue * 2.0) / 2.0
        return roundedToNearestHalf
    }

    // MARK: - Body
    var body: some View {
        
        GeometryReader { geometry in
            
    
            // Main Content now starts here inside the NavigationStack context
            VStack {
                
                VStack(spacing: 40) {
                    
                    Text("Your Insulin Dose")
                        .font(.system(size: 34, weight: .bold))
                        .padding(.top, 40)
                    
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

                        Text(insulinDose.formatted(.number.precision(.fractionLength(insulinDose.truncatingRemainder(dividingBy: 1) == 0 ? 0 : 1))))
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
            // The default back button will now appear automatically.
            
            
            
        }
    }
}
#Preview {
    CalculateView(totalCarbs: 90)
}

//
//  TimerView.swift
//  AllAble
//
//  Created by Rana Alngashy on 12/06/1447 AH.
//

//
//  TimerView.swift
//  AllAble
//
//  Created by Rana Alngashy on 12/06/1447 AH.
//

import SwiftUI

struct TimerView: View {
    
    @StateObject var viewModel = TimerViewModel()
    
    // 1. Inject AppFlow to pass the correct avatar to CongratsView
    @EnvironmentObject var appFlow: AppFlowViewModel
    @EnvironmentObject var router: NotificationRouter
    
    @State private var navigateToCongratsView = false
    
    let timerCircleColor = Color(red: 0.60, green: 0.82, blue: 0.80)
    let customBackground = Color(red: 0.97, green: 0.96, blue: 0.92)
    let circleSize: CGFloat = 250

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                
                VStack {
                    Text("Insulin Timer")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 50)
                    
                    Spacer()
                    
                    // ————— TIMER CIRCLE —————
                    ZStack {
                        Circle()
                            .stroke(timerCircleColor, lineWidth: 10)
                            .fill(timerCircleColor.opacity(0.3))
                            .frame(width: circleSize, height: circleSize)
                        
                        Text(viewModel.timeString)
                            .font(.system(size: 70, weight: .bold))
                            .foregroundColor(viewModel.timeRemaining > 0 ? .primary : .red)
                            .monospacedDigit()
                    }
                    
                    Spacer()
                    
                    // ————— START BUTTON —————
                    Button(action: {
                        if !viewModel.isActive && viewModel.timeRemaining > 0 {
                            viewModel.start()
                        }
                    }) {
                        Text(viewModel.isActive ? "Timer Running..." : "Start Timer")
                            .font(.title3.bold())
                            .frame(maxWidth: 250)
                            .padding(.vertical, 15)
                            .background(viewModel.isActive ? Color.gray.opacity(0.5) : Color.white)
                            .foregroundColor(viewModel.isActive ? .white : .black)
                            .cornerRadius(14)
                            .shadow(radius: 3)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                    .disabled(viewModel.isActive || viewModel.isFinished)
                    .padding(.bottom, 50)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(customBackground.ignoresSafeArea())
                
            }
        }
        .onDisappear {
            viewModel.stop()
        }
        // 🛑 FIXED: Use onChange instead of onReceive for reliable state observation
        .onChange(of: viewModel.isFinished) { finished in
            if finished {
                print("Timer finished! Navigating to CongratsView...")
                navigateToCongratsView = true
            }
        }
        // 🛑 FIXED: Remove the 'avatarType' parameter.
                // CongratsView now reads the avatar directly from the 'appFlow' environment object.
                .navigationDestination(isPresented: $navigateToCongratsView) {
                    CongratsView()
                        .environmentObject(appFlow)
                        .environmentObject(router)
                }
    }
}

#Preview {
    TimerView()
        .environmentObject(AppFlowViewModel())
}

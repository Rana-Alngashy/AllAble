//
//  TimerView.swift
//  AllAble
//
//  Created by Rana Alngashy on 12/06/1447 AH.
//

// TimerView.swift
//import SwiftUI
//
//struct TimerView: View {
//    
//    @StateObject var viewModel = TimerViewModel()
//    @State private var navigateToCongratsView = false
//    
//    let timerCircleColor = Color(red: 0.60, green: 0.82, blue: 0.80)
//    let customBackground = Color(red: 0.97, green: 0.96, blue: 0.92)
//    
//    // Define sizes
//    let circleSize: CGFloat = 250
//    // Increased avatar size significantly for the large iPad interface
//    let avatarSize: CGFloat = 450
//    @Environment(\.horizontalSizeClass) private var hSize
//       private var isCompact: Bool { hSize == .compact }   // iPhone
//       
//    var body: some View {
//        GeometryReader { geometry in
//            
//            // 🛑 ZStack to overlay the avatar on the right side of the main content 🛑
//            ZStack(alignment: .center) {
//                
//                // ————— MAIN CONTENT (Centered Timer) —————
//                VStack {
//                    
//                    Text("Insulin Timer")
//                        .font(.largeTitle)
//                        .bold()
//                        .padding(.top, 50)
//                    
//                    Spacer()
//                    
//                    // ————— TIMER CIRCLE DISPLAY (Perfectly Centered) —————
//                    ZStack {
//                        Circle()
//                            .stroke(timerCircleColor, lineWidth: 10)
//                            .fill(timerCircleColor.opacity(0.3))
//                            .frame(width: circleSize, height: circleSize)
//                        
//                        Text(viewModel.timeString)
//                            .font(.system(size: 70, weight: .bold))
//                            .foregroundColor(viewModel.timeRemaining > 0 ? .primary : .red)
//                            .monospacedDigit()
//                    }
//                    
//                    // Empty space that pushes the timer up, allowing the avatar to fit below the title
//                    Spacer()
//                    
//                    // ————— START/FINISH BUTTON —————
//                    Button(action: {
//                        if !viewModel.isActive && viewModel.timeRemaining > 0 {
//                            viewModel.start()
//                        }
//                    }) {
//                        Text(viewModel.isActive ? "Timer Running..." : "Start Timer")
//                            .font(.title3.bold())
//                            .frame(maxWidth: 250)
//                            .padding(.vertical, 15)
//                            .background(viewModel.isActive ? Color.gray.opacity(0.5) : Color.white)
//                            .foregroundColor(viewModel.isActive ? .white : .black)
//                            .cornerRadius(14)
//                            .shadow(radius: 3)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 14)
//                                    .stroke(Color.gray, lineWidth: 1)
//                            )
//                    }
//                    .disabled(viewModel.isActive || viewModel.isFinished)
//                    .padding(.bottom, 50)
//                    
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background(customBackground.ignoresSafeArea())
//                
//                // 🛑 AVATAR OVERLAY (Moved to the Right) 🛑
//                // We align the avatar to the trailing edge and push it down
//                // to appear next to the circle, filling the space.
//               // Image("AvatarGirl2")
//                   // .resizable()
//                  //  .scaledToFit()
//                  //  .frame(width: avatarSize, height: avatarSize)
//                    // Anchor to the center of the right half of the screen
//                   // .offset(x: geometry.size.width / 4, y: 50)
//                   // .allowsHitTesting(false) // Prevents the image from blocking button taps
//                
//            } // End ZStack
//            
//        } // End GeometryReader
//
//        .onDisappear {
//            viewModel.stop()
//        }
//        .onReceive(viewModel.$isFinished) { finished in
//            if finished {
//                navigateToCongratsView = true
//            }
//        }
//        .navigationDestination(isPresented: $navigateToCongratsView) {
//            CongratsView(avatarType: "female")
//        }
//    }
//}
//#Preview {
//   TimerView()
//}

import SwiftUI

struct TimerView: View {
    
    @StateObject var viewModel = TimerViewModel()
    @State private var navigateToCongratsView = false
    
    let timerCircleColor = Color(red: 0.60, green: 0.82, blue: 0.80)
    let customBackground = Color(red: 0.97, green: 0.96, blue: 0.92)
    
    @Environment(\.horizontalSizeClass) private var hSize
    private var isCompact: Bool { hSize == .compact }   // iPhone
    
    // Sizes depend on device
    private var circleSize: CGFloat { isCompact ? 200 : 250 }
    private var timeFontSize: CGFloat { isCompact ? 48 : 70 }
    private var buttonWidth: CGFloat { isCompact ? 220 : 250 }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                VStack {
                    
                    // ————— TITLE —————
                    Text("Insulin Timer")
                        .font(isCompact ? .title2 : .largeTitle)
                        .bold()
                        .padding(.top, isCompact ? 30 : 50)
                    
                    Spacer()
                    
                    // ————— TIMER CIRCLE —————
                    ZStack {
                        Circle()
                            .stroke(timerCircleColor, lineWidth: isCompact ? 8 : 10)
                            .fill(timerCircleColor.opacity(0.3))
                            .frame(width: circleSize, height: circleSize)
                        
                        Text(viewModel.timeString)
                            .font(.system(size: timeFontSize, weight: .bold))
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
                            .font(isCompact ? .title3 : .title3)
                            .bold()
                            .frame(maxWidth: buttonWidth)
                            .padding(.vertical, isCompact ? 14 : 15)
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
                    .padding(.bottom, isCompact ? 30 : 50)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(customBackground.ignoresSafeArea())
            }
        }
        .onDisappear {
            viewModel.stop()
        }
        .onReceive(viewModel.$isFinished) { finished in
            if finished {
                navigateToCongratsView = true
            }
        }
        .navigationDestination(isPresented: $navigateToCongratsView) {
            CongratsView(avatarType: "female")
        }
    }
}

#Preview {
    TimerView()
}


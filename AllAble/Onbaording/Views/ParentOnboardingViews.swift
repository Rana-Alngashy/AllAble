//
//  ParentOnboardingViews.swift
//  AllAble
//
//  Created by Rana Alngashy on 13/06/1447 AH.
//

//
//  ParentOnboardingViews.swift
//  AllAble
//
//

import SwiftUI

// MARK: - 1. Splash View
struct SplashView: View {
    var body: some View {
        ZStack {
            AppTheme.primaryYellow.ignoresSafeArea()
            VStack {
                Image(systemName: "heart.text.square.fill") // Replace with App Logo
                    .font(.system(size: 100))
                    .foregroundColor(.white)
                Text("AllAble")
                    .font(.system(size: 60, weight: .heavy))
                    .foregroundColor(.black.opacity(0.8))
            }
        }
    }
}

// MARK: - 2. Parent Login (Nafath)
struct ParentLoginView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            VStack(spacing: 40) {
                Text("Parent Verification")
                    .font(.largeTitle.bold())
                    .foregroundColor(.gray)
                
                VStack(spacing: 20) {
                    Text("Please enter your National ID to verify via Nafath")
                        .font(.title3)
                    
                    TextField("National ID", text: $viewModel.nationalID)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 400)
                }
                
                PrimaryButton(title: "Verify with Nafath", isLoading: viewModel.isLoading) {
                    Task {
                        await viewModel.triggerNafathVerification()
                        if viewModel.isNafathVerified {
                            path.append("Acknowledgement")
                        }
                    }
                }
                .frame(width: 400)
                
                if let error = viewModel.errorMessage {
                    Text(error).foregroundColor(.red)
                }
            }
        }
    }
}

// MARK: - 3. Acknowledgment
struct AcknowledgmentView: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            VStack(spacing: 30) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 80))
                    .foregroundColor(AppTheme.primaryYellow)
                
                Text("Verification Successful")
                    .font(.largeTitle.bold())
                
                Text("I hereby acknowledge that I am the legal guardian of the child and authorize the use of AllAble to assist in managing their insulin doses.")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: 600)
                
                PrimaryButton(title: "I Agree & Continue") {
                    path.append("ChildInfo")
                }
                .frame(width: 300)
            }
        }
    }
}

// MARK: - 4. Child Info
struct ChildInfoView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            VStack(spacing: 40) {
                Text("Child Profile")
                    .font(.largeTitle.bold())
                
                VStack(spacing: 20) {
                    TextField("Child's Name", text: $viewModel.childName)
                        .padding()
                        .background(.white).cornerRadius(12)
                    
                    TextField("Child's Age", text: $viewModel.childAge)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(.white).cornerRadius(12)
                }
                .frame(maxWidth: 450)
                .font(.title2)
                
                PrimaryButton(title: "Next") {
                    if !viewModel.childName.isEmpty {
                        path.append("CarbRatio")
                    }
                }
                .frame(width: 450)
            }
        }
    }
}

// MARK: - 5. Carb Ratio Verification
struct CarbRatioVerificationView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            VStack(spacing: 40) {
                Text("Insulin-to-Carb Ratio (ICR)")
                    .font(.largeTitle.bold())
                
                HStack(spacing: 30) {
                    // Option A: Sehaty
                    VerificationOptionCard(
                        icon: "link.icloud.fill",
                        title: "Fetch from Sehaty",
                        isSelected: viewModel.selectedSource == .sehaty
                    ) {
                        viewModel.selectedSource = .sehaty
                    }
                    
                    // Option B: Manual
                    VerificationOptionCard(
                        icon: "doc.text.fill",
                        title: "Manual Upload",
                        isSelected: viewModel.selectedSource == .manual
                    ) {
                        viewModel.selectedSource = .manual
                    }
                }
                
                if viewModel.selectedSource == .sehaty {
                    VStack {
                        if viewModel.carbRatioInput.isEmpty {
                            Button("Fetch Data") {
                                Task { await viewModel.fetchICRFromSehaty() }
                            }
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                        } else {
                            Text("Retrieved Ratio: 1 unit / \(viewModel.carbRatioInput)g")
                                .font(.title)
                                .foregroundColor(.green)
                        }
                    }
                } else {
                    VStack(spacing: 15) {
                        TextField("Enter Ratio (e.g. 15)", text: $viewModel.carbRatioInput)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(.white)
                            .cornerRadius(12)
                            .frame(width: 200)
                        
                        Button(action: {
                            Task { await viewModel.uploadDocument() }
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text(viewModel.medicalDocName ?? "Upload Medical Report")
                            }
                            .foregroundColor(.blue)
                        }
                    }
                }
                
                if viewModel.isLoading { ProgressView() }
                
                PrimaryButton(title: "Confirm & Continue") {
                    path.append("AvatarSelection")
                }
                .frame(width: 400)
                .disabled(viewModel.carbRatioInput.isEmpty)
            }
        }
    }
}

struct VerificationOptionCard: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 40))
                Text(title)
                    .font(.headline)
            }
            .frame(width: 200, height: 150)
            .background(isSelected ? AppTheme.primaryYellow : .white)
            .foregroundColor(.black)
            .cornerRadius(20)
            .shadow(radius: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.black : Color.clear, lineWidth: 3)
            )
        }
    }
}


// MARK: - 6. Avatar Selection
struct AvatarSelectionView: View {
    @EnvironmentObject var appFlow: AppFlowViewModel
    @ObservedObject var viewModel: OnboardingViewModel
    
    // UPDATED: Now uses "AvatarGirl" and "AvatarBoy"
    let avatars = ["AvatarGirl", "AvatarBoy"]
    
    @State private var selectedAvatar = "AvatarGirl"
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            VStack(spacing: 40) {
                Text("Pick Your Hero!")
                    .font(.largeTitle.bold())
                
                HStack(spacing: 60) { // Increased spacing slightly for better separation
                    ForEach(avatars, id: \.self) { avatar in
                        VStack {
                            Image(avatar) // Assumes "AvatarGirl" and "AvatarBoy" exist in Assets
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(
                                            selectedAvatar == avatar ? AppTheme.primaryYellow : Color.clear,
                                            lineWidth: 6
                                        )
                                )
                                .shadow(radius: selectedAvatar == avatar ? 10 : 0) // Optional: Add shadow to selected
                                .scaleEffect(selectedAvatar == avatar ? 1.1 : 1.0) // Optional: Scale up selected
                                .animation(.spring(), value: selectedAvatar)
                                .onTapGesture {
                                    selectedAvatar = avatar
                                }
                        }
                    }
                }
                .padding()
                
                PrimaryButton(title: "Finish Setup") {
                    // Update main app model
                    appFlow.childProfile.name = viewModel.childName
                    appFlow.childProfile.avatarName = selectedAvatar
                    appFlow.childProfile.carbRatio = Double(viewModel.carbRatioInput) ?? 0.0
                    
                    // Switch to Child Mode
                    appFlow.completeOnboarding()
                }
                .frame(width: 300)
            }
        }
    }
}

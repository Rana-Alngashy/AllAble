//
//  AvatarSelectionView.swift
//  AllAble
//
//  Created by Wteen Alghamdy on 15/06/1447 AH.
//
import SwiftUI

struct AvatarSelectionView: View {
    @StateObject var viewModel = AvatarSelectionViewModel()
    
    let backgroundColor = Color(red: 0.97, green: 0.96, blue: 0.92)
    let primaryColor = Color(red: 0.99, green: 0.85, blue: 0.33)
    
    @Environment(\.horizontalSizeClass) private var hSize
    private var isCompact: Bool { true}
    @EnvironmentObject var carbRatioStore: CarbRatioStore // ✅ إضافة CarbRatioStore
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            VStack(spacing: isCompact ? 24 : 40) {
                
                // ————— TITLE —————
                Text("Title.ChooseCharacter")
                    .font(isCompact ? .title2 : .largeTitle)
                    .bold()
                    .padding(.top, isCompact ? 40 : 80)
                    .foregroundColor(.gray)
                
                Spacer()
                
                // ————— AVATARS —————
                if isCompact {
                    // 📱 iPhone: عمودي
                    VStack(spacing: 24) {
                        ForEach(viewModel.availableAvatars) { avatar in
                            AvatarCardView(
                                avatar: avatar,
                                isSelected: viewModel.selectedAvatar == avatar,
                                primaryColor: primaryColor,
                                isCompact: true
                            )
                            .onTapGesture {
                                withAnimation {
                                    viewModel.selectAvatar(avatar)
                                }
                            }
                        }
                    }
                } else {
                    // 💻 iPad: أفقي
                    HStack(spacing: 80) {
                        ForEach(viewModel.availableAvatars) { avatar in
                            AvatarCardView(
                                avatar: avatar,
                                isSelected: viewModel.selectedAvatar == avatar,
                                primaryColor: primaryColor,
                                isCompact: false
                            )
                            .onTapGesture {
                                withAnimation {
                                    viewModel.selectAvatar(avatar)
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                // ————— NEXT BUTTON —————
                Button(action: viewModel.handleNextButton) {
                    Text("Button.Next")                        .font(isCompact ? .title3 : .title2)
                        .bold()
                        .frame(maxWidth: isCompact ? .infinity : 250)
                        .frame(height: isCompact ? 50 : 60)
                        .background(viewModel.isNextButtonEnabled ? primaryColor : Color.gray.opacity(0.3))
                        .foregroundColor(viewModel.isNextButtonEnabled ? .black : .white)
                        .cornerRadius(15)
                }
                .disabled(!viewModel.isNextButtonEnabled)
                .padding(.horizontal, isCompact ? 20 : 0)
                .padding(.bottom, isCompact ? 20 : 50)
            }
            .environment(\.layoutDirection, .rightToLeft)
        }
        .environment(\.layoutDirection, .rightToLeft)
        .fullScreenCover(isPresented: $viewModel.shouldNavigateToInfo) {
            if let avatar = viewModel.selectedAvatar {
                InfoView(selectedAvatar: avatar)
                    // ✅ تمرير CarbRatioStore
                    .environmentObject(carbRatioStore)
            } else {
                Text("Error: Avatar Selection Failed")
            }
        }
    }
}
struct AvatarCardView: View {
// ... (بقية الكود كما هو)
    let avatar: Avatar
    let isSelected: Bool
    let primaryColor: Color
    let isCompact: Bool

    var body: some View {
        VStack {
            Image(avatar.imageName)
                .resizable()
                .scaledToFit()
                .frame(
                    width: isCompact ? 180 : 300,
                    height: isCompact ? 180 : 300
                )
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(isSelected ? primaryColor.opacity(0.3) : Color.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(isSelected ? primaryColor : Color.clear, lineWidth: 3)
                )
                .shadow(radius: isSelected ? 10 : 3)
        }
    }
}
















////
//import SwiftUI
//
//struct AvatarSelectionView: View {
//    @StateObject var viewModel = AvatarSelectionViewModel()
//    
//    let backgroundColor = Color(red: 0.97, green: 0.96, blue: 0.92)
//    let primaryColor = Color(red: 0.99, green: 0.85, blue: 0.33)
//    
//    @Environment(\.horizontalSizeClass) private var hSize
//    private var isCompact: Bool { true}  
//    var body: some View {
//        ZStack {
//            backgroundColor.ignoresSafeArea()
//            
//            VStack(spacing: isCompact ? 24 : 40) {
//                
//                // ————— TITLE —————
//                Text("Title.ChooseCharacter")
//                    .font(isCompact ? .title2 : .largeTitle)
//                    .bold()
//                    .padding(.top, isCompact ? 40 : 80)
//                    .foregroundColor(.gray)
//                
//                Spacer()
//                
//                // ————— AVATARS —————
//                if isCompact {
//                    // 📱 iPhone: عمودي
//                    VStack(spacing: 24) {
//                        ForEach(viewModel.availableAvatars) { avatar in
//                            AvatarCardView(
//                                avatar: avatar,
//                                isSelected: viewModel.selectedAvatar == avatar,
//                                primaryColor: primaryColor,
//                                isCompact: true
//                            )
//                            .onTapGesture {
//                                withAnimation {
//                                    viewModel.selectAvatar(avatar)
//                                }
//                            }
//                        }
//                    }
//                } else {
//                    // 💻 iPad: أفقي
//                    HStack(spacing: 80) {
//                        ForEach(viewModel.availableAvatars) { avatar in
//                            AvatarCardView(
//                                avatar: avatar,
//                                isSelected: viewModel.selectedAvatar == avatar,
//                                primaryColor: primaryColor,
//                                isCompact: false
//                            )
//                            .onTapGesture {
//                                withAnimation {
//                                    viewModel.selectAvatar(avatar)
//                                }
//                            }
//                        }
//                    }
//                }
//                
//                Spacer()
//                
//                // ————— NEXT BUTTON —————
//                Button(action: viewModel.handleNextButton) {
//                    Text("Button.Next")                        .font(isCompact ? .title3 : .title2)
//                        .bold()
//                        .frame(maxWidth: isCompact ? .infinity : 250)
//                        .frame(height: isCompact ? 50 : 60)
//                        .background(viewModel.isNextButtonEnabled ? primaryColor : Color.gray.opacity(0.3))
//                        .foregroundColor(viewModel.isNextButtonEnabled ? .black : .white)
//                        .cornerRadius(15)
//                }
//                .disabled(!viewModel.isNextButtonEnabled)
//                .padding(.horizontal, isCompact ? 20 : 0)
//                .padding(.bottom, isCompact ? 20 : 50)
//            }
//            .environment(\.layoutDirection, .rightToLeft)
//        }
//        .environment(\.layoutDirection, .rightToLeft)
//        .fullScreenCover(isPresented: $viewModel.shouldNavigateToInfo) {
//            if let avatar = viewModel.selectedAvatar {
//                InfoView(selectedAvatar: avatar)
//            } else {
//                Text("Error: Avatar Selection Failed")
//            }
//        }
//    }
//}
//struct AvatarCardView: View {
//    let avatar: Avatar
//    let isSelected: Bool
//    let primaryColor: Color
//    let isCompact: Bool
//
//    var body: some View {
//        VStack {
//            Image(avatar.imageName)
//                .resizable()
//                .scaledToFit()
//                .frame(
//                    width: isCompact ? 180 : 300,
//                    height: isCompact ? 180 : 300
//                )
//                .clipShape(RoundedRectangle(cornerRadius: 25))
//                .background(
//                    RoundedRectangle(cornerRadius: 25)
//                        .fill(isSelected ? primaryColor.opacity(0.3) : Color.white)
//                )
//                .overlay(
//                    RoundedRectangle(cornerRadius: 25)
//                        .stroke(isSelected ? primaryColor : Color.clear, lineWidth: 3)
//                )
//                .shadow(radius: isSelected ? 10 : 3)
//        }
//    }
//}
//
//

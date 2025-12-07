//
//  AvatarSelectionView.swift
//  AllAble
//
//  Created by Wteen Alghamdy on 15/06/1447 AH.
//

//import SwiftUI
//
//struct AvatarSelectionView: View {
//    @StateObject var viewModel = AvatarSelectionViewModel()
//    
//    // FIX: تعريف الألوان محلياً بدلاً من AppConstants
//    let backgroundColor = Color(red: 0.97, green: 0.96, blue: 0.92)
//    let primaryColor = Color(red: 0.99, green: 0.85, blue: 0.33)
//    
//    var body: some View {
//        ZStack {
//            backgroundColor.edgesIgnoringSafeArea(.all)
//            
//            VStack {
//                Text("Choose Your Character")
//                    .font(.largeTitle)
//                    .bold()
//                    .padding(.top, 80)
//                    .padding(.bottom, 40)
//                    .foregroundColor(Color.gray)
//                
//                Spacer()
//
//                HStack(spacing: 200) {
//                    ForEach(viewModel.availableAvatars) { avatar in
//                        AvatarCardView(
//                            avatar: avatar,
//                            isSelected: viewModel.selectedAvatar == avatar,
//                            primaryColor: primaryColor // تمرير اللون
//                        )
//                        .onTapGesture {
//                            withAnimation {
//                                viewModel.selectAvatar(avatar)
//                            }
//                        }
//                    }
//                }
//                .padding(.top, 50)
//                Spacer()
//                
//                Button(action: viewModel.handleNextButton) {
//                    Text("NEXT")
//                        .font(.title2.bold())
//                        .frame(width: 250, height: 60)
//                        .background(viewModel.isNextButtonEnabled ? primaryColor : Color.gray.opacity(0.3))
//                        .foregroundColor(viewModel.isNextButtonEnabled ? .black : .white)
//                        .cornerRadius(15)
//                }
//                .disabled(!viewModel.isNextButtonEnabled)
//                .padding(.bottom, 50)
//            }
//            .environment(\.layoutDirection, .rightToLeft) // FIX: تطبيق اتجاه العرض
//        }
//        .fullScreenCover(isPresented: $viewModel.shouldNavigateToInfo) {
//            if let avatar = viewModel.selectedAvatar {
//                InfoView(selectedAvatar: avatar)
//            } else {
//                Text("Error: Avatar Selection Failed")
//            }
//        }
//    }
//}
//
//struct AvatarCardView: View {
//    let avatar: Avatar
//    let isSelected: Bool
//    let primaryColor: Color // استقبال اللون
//    
//    var body: some View {
//        VStack {
//            // FIX: اسم الصورة الآن موحد من Avatar.swift
//            Image(avatar.imageName)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 300, height: 300)
//                .clipShape(RoundedRectangle(cornerRadius: 25))
//                .background(
//                    RoundedRectangle(cornerRadius: 25)
//                        .fill(isSelected ? primaryColor.opacity(0.3) : Color.clear)
//                )
//                .shadow(radius: isSelected ? 10 : 3)
//        }
//    }
//}
//
//// يمكنك ترك AvatarSelectionViewModel.swift كما هو، فهو سيعمل مع Avatar.swift المحدث.












import SwiftUI

struct AvatarSelectionView: View {
    @StateObject var viewModel = AvatarSelectionViewModel()
    
    // FIX: تعريف الألوان محلياً بدلاً من AppConstants
    let backgroundColor = Color(red: 0.97, green: 0.96, blue: 0.92)
    let primaryColor = Color(red: 0.99, green: 0.85, blue: 0.33)
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Choose Your Character")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 80)
                    .padding(.bottom, 40)
                    .foregroundColor(Color.gray)
                
                Spacer()

                HStack(spacing: 200) {
                    ForEach(viewModel.availableAvatars) { avatar in
                        AvatarCardView(
                            avatar: avatar,
                            isSelected: viewModel.selectedAvatar == avatar,
                            primaryColor: primaryColor
                        )
                        .onTapGesture {
                            withAnimation {
                                viewModel.selectAvatar(avatar)
                            }
                        }
                    }
                }
                .padding(.top, 50)
                Spacer()
                
                Button(action: viewModel.handleNextButton) {
                    Text("NEXT")
                        .font(.title2.bold())
                        .frame(width: 250, height: 60)
                        .background(viewModel.isNextButtonEnabled ? primaryColor : Color.gray.opacity(0.3))
                        .foregroundColor(viewModel.isNextButtonEnabled ? .black : .white)
                        .cornerRadius(15)
                }
                .disabled(!viewModel.isNextButtonEnabled)
                .padding(.bottom, 50)
            }
            .environment(\.layoutDirection, .rightToLeft) // FIX: تطبيق اتجاه العرض
        }
        .fullScreenCover(isPresented: $viewModel.shouldNavigateToInfo) {
            if let avatar = viewModel.selectedAvatar {
                InfoView(selectedAvatar: avatar)
            } else {
                Text("Error: Avatar Selection Failed")
            }
        }
    }
}

// NOTE: هذا الـ struct يجب وضعه في نفس ملف AvatarSelectionView.swift
struct AvatarCardView: View {
    let avatar: Avatar
    let isSelected: Bool
    let primaryColor: Color
    
    var body: some View {
        VStack {
            Image(avatar.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(isSelected ? primaryColor.opacity(0.3) : Color.clear)
                )
                .shadow(radius: isSelected ? 10 : 3)
        }
    }
}

//
//  AvatarSelectionViewModel.swift
//  AllAble
//
//  Created by Wteen Alghamdy on 15/06/1447 AH.
//








import Foundation
import Combine
import SwiftUI

class AvatarSelectionViewModel: ObservableObject {
    @Published var selectedAvatar: Avatar? = nil
    @Published var shouldNavigateToInfo = false
    @AppStorage("selectedAvatarImageName") private var storedAvatarName: String = ""

    let availableAvatars = Avatar.allAvatars
    
    var isNextButtonEnabled: Bool {
        return selectedAvatar != nil
    }
    
    func selectAvatar(_ avatar: Avatar) {
        selectedAvatar = (selectedAvatar?.id == avatar.id) ? nil : avatar
    }
    
    func handleNextButton() {
        if let avatar = selectedAvatar {
            storedAvatarName = avatar.imageName   // 👈 حفظ أسم صورة الأفتار
            shouldNavigateToInfo = true
        }
    }

}

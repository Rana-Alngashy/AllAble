//
//  Avatar.swift
//  AllAble
//
//  Created by Wteen Alghamdy on 14/06/1447 AH.
//
import Foundation

struct Avatar: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let imageName: String // اسم الـ Asset في المشروع الكامل
    
    // FIX: تم تحديث أسماء الصور لتتوافق مع "AvatarBoy" و "AvatarGirl"
    static let girlAvatar = Avatar(name: "Girl", imageName: "AvatarGirl")
    static let boyAvatar = Avatar(name: "Boy", imageName: "AvatarBoy")
    
    static let allAvatars: [Avatar] = [girlAvatar, boyAvatar]
}

//
//  MealItem.swift
//  AllAble
//
//  Created by lamess on 10/06/1447 AH.
//
import SwiftUI

struct MealItem: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let color: Color
}

//
//  DesignSystem.swift
//  AllAble
//
//  Created by Rana Alngashy on 13/06/1447 AH.
//

//
//  DesignSystem.swift
//  AllAble
//
//

import SwiftUI

struct AppTheme {
    static let primaryYellow = Color(red: 0.99, green: 0.85, blue: 0.33)
    static let background = Color(red: 0.97, green: 0.96, blue: 0.92)
    static let cardBackground = Color.white
}

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    
    var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .tint(.black)
                } else {
                    Text(title)
                        .font(.system(size: 24, weight: .bold))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(AppTheme.primaryYellow)
            .foregroundColor(.black)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
        }
        .disabled(isLoading)
    }
}

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(Color.white)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppTheme.primaryYellow, lineWidth: 3)
                )
        }
    }
}

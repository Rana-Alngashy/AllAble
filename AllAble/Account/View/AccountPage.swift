//
//  Untitled.swift
//  AllAble
//
//  Created by NORAH on 11/06/1447 AH.
//
//
//  AccountPage.swift
//  AllAble
//
//  Created by AllAble Architect.
//

import SwiftUI

struct AccountPage: View {
    @Environment(\.dismiss) private var dismiss
    
    // 1. Access Shared Data
    @EnvironmentObject var appFlow: AppFlowViewModel

    // Local State for Editing
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var guardianNumber: String = ""
    @State private var carbonValue: String = ""
    @State private var selectedAvatar: String = "AvatarGirl"

    let paleYellow = Color(red: 0.98, green: 0.96, blue: 0.90)

    // Custom Input Field Component
    struct InputField: View {
        let label: String
        @Binding var text: String
        var isNumber: Bool = false // Option to set keyboard type

        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text(label)
                    .font(.system(size: 17))
                    .foregroundColor(.black.opacity(0.9))
                    .frame(maxWidth: .infinity, alignment: .leading)

                TextField("", text: $text)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: .gray.opacity(0.2), radius: 1, x: 0, y: 1)
                    .keyboardType(isNumber ? .numberPad : .default)
            }
        }
    }

    // Main Body
    var body: some View {
        ZStack {
            paleYellow.ignoresSafeArea()

            VStack(spacing: 0) {
                
                // --- Editable Avatar Section ---
                ZStack {
                    Ellipse()
                        .fill(Color.white)
                        .frame(width: 230, height: 260)
                        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)

                    VStack {
                        Image(selectedAvatar) // Displays currently selected avatar
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .onTapGesture {
                                toggleAvatar()
                            }
                        
                        Text("Tap to change")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 40)

                // --- Input Fields ---
                GeometryReader { geometry in
                    VStack(spacing: 35) {
                        InputField(label: "Name", text: $name)
                        InputField(label: "Age", text: $age, isNumber: true)
                        InputField(label: "Guardian Number", text: $guardianNumber, isNumber: true)
                        InputField(label: "Carb Ratio (ICR)", text: $carbonValue, isNumber: true)
                    }
                    .frame(width: geometry.size.width * 0.75)
                    .padding(.top, 40)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
                .frame(height: 350)

                // --- Save Button ---
                Button(action: {
                    saveAndExit()
                }) {
                    Text("Save Changes")
                        .font(.headline)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .background(Color(red: 0.99, green: 0.85, blue: 0.33))
                        .foregroundColor(.black)
                        .cornerRadius(15)
                        .shadow(radius: 3)
                }
                .padding(.top, 50)

                Spacer()
            }
        }
        .environment(\.layoutDirection, .leftToRight)
        .onAppear {
            loadCurrentData()
        }
    }
    
    // MARK: - Logic Functions
    
    func loadCurrentData() {
        // Load current data from the AppFlow model
        name = appFlow.childProfile.name
        age = appFlow.childProfile.age
        guardianNumber = appFlow.childProfile.guardianNumber
        
        // Format carb ratio (remove decimals if whole number)
        let carbRatio = appFlow.childProfile.carbRatio
        carbonValue = carbRatio.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", carbRatio) : String(carbRatio)
        
        selectedAvatar = appFlow.childProfile.avatarName
    }
    
    func toggleAvatar() {
        // Toggle between Girl and Boy
        if selectedAvatar == "AvatarGirl" {
            selectedAvatar = "AvatarBoy"
        } else {
            selectedAvatar = "AvatarGirl"
        }
    }
    
    func saveAndExit() {
        // Update the main ViewModel instantly
        appFlow.updateProfile(
            name: name,
            age: age,
            guardianNumber: guardianNumber,
            carbRatio: Double(carbonValue) ?? 15.0,
            avatarName: selectedAvatar
        )
        
        // Close the page
        dismiss()
    }
}

#Preview {
    AccountPage()
        .environmentObject(AppFlowViewModel())
}

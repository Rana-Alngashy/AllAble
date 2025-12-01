//
//  MainPage.swift
//  AllAble
//
//  Created by lamess on 10/06/1447 AH.
//


import SwiftUI

struct MainPage: View {
    
    @StateObject private var viewModel = MainPageViewModel()
    
    var body: some View {
        ZStack {
            
            // Background
            Color(red: 254/255, green: 251/255, blue: 244/255)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 24) {
                
                // MARK: - Top Toolbar
                HStack(spacing: 20) {
                    Button { viewModel.openProfile() } label: {
                        Image(systemName: "person.crop.circle")
                            .font(.system(size: 50))
                            .foregroundColor(.black)
                    }
                    
                    Button { viewModel.openNotifications() } label: {
                        Image(systemName: "bell")
                            .font(.system(size: 50))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                HStack(alignment: .center) {
                    
                    // MARK: - Dose Card
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text("آخر حساب لجرعة الأنسولين")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                        
                        VStack(alignment: .center) {
                            Text("\(viewModel.lastDose)")
                                .font(.system(size: 62, weight: .bold))
                                .foregroundColor(Color(red: 20/255, green: 40/255, blue: 90/255))
                            
                            Text("للغداء")
                                .font(.system(size: 32, weight: .semibold))
                                .foregroundColor(Color(red: 20/255, green: 40/255, blue: 90/255))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 28)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.06), radius: 5)
                        
                        // MARK: - Yellow Button
                        Button {
                            viewModel.calculateMeal()
                        } label: {
                            Text("احسب وجبتي")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 255/255, green: 223/255, blue: 112/255))
                                .cornerRadius(14)
                        }
                        
                        // MARK: - Outline Button
                        Button {
                            viewModel.showPreviousMeals()
                        } label: {
                            Text("وجباتي السابقة")
                                .font(.system(size: 22, weight: .medium))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Color(red: 255/255, green: 223/255, blue: 112/255), lineWidth: 3)
                                )
                        }
                        
                    }
                    .padding(.leading, 24)
                    
                    
                    Spacer()
                    
                    // MARK: - User Image
                    VStack(spacing: 12) {
                        Image("AvatarGirl") // أضيفي الصورة داخل Assets
                            .resizable()
                            .scaledToFit()
                            .frame(width: 220, height: 260)
                            .background(Color.white)
                            .cornerRadius(30)
                            .shadow(color: .black.opacity(0.06), radius: 5)
                        
                        Text(viewModel.userName)
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(.black)
                    }
                    .padding(.trailing, 30)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    MainPage()
}

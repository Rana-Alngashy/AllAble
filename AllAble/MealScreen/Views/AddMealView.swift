//
//  AddMealView.swift
//  AllAble
//
//  Created by lamess on 10/06/1447 AH.
//

import SwiftUI

struct AddMealView: View {

    @StateObject var viewModel = AddMealViewModel()

    var body: some View {

        NavigationStack {
            ZStack {
                Color(#colorLiteral(red: 0.97, green: 0.96, blue: 0.92, alpha: 1))
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 50) {

                 

                    // ————— PAGE TITLE ——————
                    Text("Calculate My Meal")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.gray.opacity(0.9))
                        .padding(.horizontal)

                    // ————— MEALS GRID ——————
                    HStack(spacing: 45) {
                        ForEach(viewModel.meals) { meal in
                            
                            NavigationLink {
                                EditMealView(meal: meal)
                            } label: {
                                VStack(spacing: 20) {
                                    Image(meal.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 250, height: 350)
                                    
                                    Text(meal.title)
                                        .font(.system(size: 34, weight: .medium))
                                        .foregroundColor(.gray.opacity(0.8))
                                }
                                .frame(width: 250, height: 500)
                                .background(meal.color)
                                .clipShape(RoundedRectangle(cornerRadius: 40))
                                .shadow(color: .black.opacity(0.12), radius: 5)
                            }
                            .buttonStyle(.plain)

                        }
                    }

                    Spacer()
                }
                .padding(.horizontal, 40)
                .padding(.top, 100)
            }
        }
    }
}

#Preview {
    AddMealView()
}

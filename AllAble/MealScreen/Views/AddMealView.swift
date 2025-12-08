//
//  AddMealView.swift
//  AllAble
//
//  Created by lamess on 10/06/1447 AH.
//
//
//import SwiftUI
//
//struct AddMealView: View {
//
//    @StateObject var viewModel = AddMealViewModel()
//
//    var body: some View {
//
//        NavigationStack {
//            ZStack {
//                Color(#colorLiteral(red: 0.97, green: 0.96, blue: 0.92, alpha: 1))
//                    .ignoresSafeArea()
//
//                VStack(alignment: .leading, spacing: 50) {
//
//                 
//
//                    // ————— PAGE TITLE ——————
//                    Text("Calculate My Meal")
//                        .font(.system(size: 42, weight: .bold))
//                        .foregroundColor(.gray.opacity(0.9))
//                        .padding(.horizontal)
//
//                    // ————— MEALS GRID ——————
//                    HStack(spacing: 45) {
//                        ForEach(viewModel.meals) { meal in
//                            
//                            NavigationLink {
//                                EditMealView(meal: meal)
//                            } label: {
//                                VStack(spacing: 20) {
//                                    Image(meal.imageName)
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 250, height: 350)
//                                    
//                                    Text(meal.title)
//                                        .font(.system(size: 34, weight: .medium))
//                                        .foregroundColor(.gray.opacity(0.8))
//                                }
//                                .frame(width: 250, height: 500)
//                                .background(meal.color)
//                                .clipShape(RoundedRectangle(cornerRadius: 40))
//                                .shadow(color: .black.opacity(0.12), radius: 5)
//                            }
//                            .buttonStyle(.plain)
//
//                        }
//                    }
//
//                    Spacer()
//                }
//                .padding(.horizontal, 40)
//                .padding(.top, 100)
//            }
//        }
//    }
//}
//
//#Preview {
//    AddMealView()
//}

import SwiftUI

struct AddMealView: View {

    @StateObject var viewModel = AddMealViewModel()
    @Environment(\.horizontalSizeClass) private var hSize

    private var isCompact: Bool {
        hSize == .compact   // iPhone
    }

    var body: some View {

        NavigationStack {
            ZStack {
                Color(#colorLiteral(red: 0.97, green: 0.96, blue: 0.92, alpha: 1))
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: isCompact ? 50 : 50) {

                    // ————— PAGE TITLE ——————
                    Text("Title.CalculateMeal")                        .font(.system(size: isCompact ? 35 : 42, weight: .bold))
                        .foregroundColor(.gray.opacity(0.9))
                        .padding(.horizontal)

                    // ————— MEALS GRID ——————
                    if isCompact {
                        ScrollView {
                            VStack(spacing: 20) {
                                ForEach(viewModel.meals) { meal in
                                    NavigationLink {
                                        EditMealView(meal: meal)
                                    } label: {
                                        HStack(spacing: 16) {
                                            
                                            Image(meal.imageName)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 90, height: 90)
                                            
                                            Text(meal.title)
                                                .font(.system(size: 20, weight: .medium))
                                                .foregroundColor(.gray.opacity(0.8))
                                            
                                            Spacer()
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(meal.color)
                                        .clipShape(RoundedRectangle(cornerRadius: 24))
                                        .shadow(color: .black.opacity(0.12), radius: 4)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
 else {
                        // 💻 iPad: نفس التصميم الأفقي
                        HStack(spacing: 45) {
                            mealCards
                        }
                        .padding(.horizontal, 40)
                    }

                    Spacer()
                }
                .padding(.top, isCompact ? 30 : 100)
            }
        }
    }

    // MARK: - Meal Cards (مشتركة بين iPhone و iPad)

    @ViewBuilder
    private var mealCards: some View {
        ForEach(viewModel.meals) { meal in
            NavigationLink {
                EditMealView(meal: meal)
            } label: {
                VStack(spacing: isCompact ? 12 : 20) {
                    Image(meal.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: isCompact ? 140 : 250,
                            height: isCompact ? 180 : 350
                        )

                    Text(meal.title)
                        .font(.system(size: isCompact ? 18 : 34, weight: .medium))
                        .foregroundColor(.gray.opacity(0.8))
                }
                .frame(
                    width: isCompact ? .infinity : 250,
                    height: isCompact ? 240 : 500
                )
                .background(meal.color)
                .clipShape(RoundedRectangle(cornerRadius: 28))
                .shadow(color: .black.opacity(0.12), radius: 5)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    AddMealView()
}

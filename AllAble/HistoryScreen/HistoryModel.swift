//
//  HistoryModel.swift
//  AllAble
//
//  Created by Wteen Alghamdy on 16/06/1447 AH.
//

//
//  HistoryModel.swift
//  AllAble
//
//  Created by NORAH on 12/06/1447 AH.
//

import Foundation

struct HistoryModel: Identifiable {
    let id = UUID()
    let mealTypeTitle: String
    let mealName: String
    let totalCarbs: Double
    let insulinDose: Double
}

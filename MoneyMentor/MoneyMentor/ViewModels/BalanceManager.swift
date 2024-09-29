//
//  BalanceManager.swift
//  MoneyMentor
//
//  Created by Mustafa Bekirov on 02.10.2024.
//

import SwiftUI

class BalanceManager: ObservableObject {
    @AppStorage("currentBalance") var currentBalance: Double = 0
    @AppStorage("pricePerClick") var pricePerClick: Double = 2
    
    // Вычисляемое свойство для форматированного отображения текущего баланса
    func correctFormatted(_ number: Double) -> String {
        String(format: "%.2f", number)
    }
    
    func earnMoneyClick() {
        currentBalance += pricePerClick
    }
    
    func costUpPerClick() {
        pricePerClick *= 1.15
    }
}

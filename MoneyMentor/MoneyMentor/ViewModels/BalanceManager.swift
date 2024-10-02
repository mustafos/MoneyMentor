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
    @AppStorage("balancePerClick") var balancePerClick: Double = 0
    
    // Вычисляемое свойство для форматированного отображения текущего баланса
    func correctFormatted(_ number: Double) -> String {
        String(format: "%.2f", number)
    }
    
    func earnMoneyClick() {
        currentBalance += pricePerClick
        balancePerClick += pricePerClick
    }
    
    func costUpPerClick() {
        pricePerClick *= 1.15
    }
    
    func resetProgress() {
        currentBalance = 0
        pricePerClick = 2
        balancePerClick = 0
    }
}

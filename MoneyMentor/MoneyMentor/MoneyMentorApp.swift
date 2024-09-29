//
//  MoneyMentorApp.swift
//  MoneyMentor
//
//  Created by Mustafa Bekirov on 23.09.2024.
//

import SwiftUI

@main
struct MoneyMentorApp: App {
    @StateObject private var balanceManager = BalanceManager()
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(balanceManager)
        }
    }
}

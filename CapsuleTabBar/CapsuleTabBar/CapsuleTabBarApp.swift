//
//  CapsuleTabBarApp.swift
//  CapsuleTabBar
//
//  Created by Mustafa Bekirov on 28.02.2024.
//

import SwiftUI

@main
struct CapsuleTabBarApp: App {
    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(Model())
        }
    }
}

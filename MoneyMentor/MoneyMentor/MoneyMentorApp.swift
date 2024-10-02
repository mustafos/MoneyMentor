//
//  MoneyMentorApp.swift
//  MoneyMentor
//
//  Created by Mustafa Bekirov on 23.09.2024.
//

import SwiftUI
//import GoogleMobileAds
//
//class AppDelegate: UIResponder, UIApplicationDelegate {
//    
//    func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        
//        GADMobileAds.sharedInstance().start(completionHandler: nil)
//        
//        return true
//    }
//}

@main
struct MoneyMentorApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var balanceManager = BalanceManager()
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(balanceManager)
        }
    }
}

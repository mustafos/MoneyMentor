//
//  Configuration.swift
//  MoneyMentor
//
//  Created by Mustafa Bekirov on 13.10.2024.
//

import Foundation

enum Configuration {
    static var appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "Unknown App Name"
    static let appleAppID = 6474212227
    static let privacyURL = "https://mustafos.github.io/privacy.html"
    static let termsURL = "https://mustafos.github.io/terms.html"
    static let admobAppID = "ca-app-pub-4744463005672993~2729884007"
    static let admobBanner = "ca-app-pub-4744463005672993/7537092788"
}

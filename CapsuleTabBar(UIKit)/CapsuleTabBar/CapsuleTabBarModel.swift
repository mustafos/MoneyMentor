//
//  CapsuleTabBarModel.swift
//  CapsuleTabBar
//
//  Created by Mustafa Bekirov on 05.03.2024.
//

import UIKit

protocol TabBarConfigurable {
    var tabBarIcon: UIImage? { get }
    var tabBarTitle: String { get }
}

struct CapsuleTabBarModel {
    let index: Int
    let icon: UIImage?
    let selectedIcon: UIImage?
    let viewController: UIViewController
}

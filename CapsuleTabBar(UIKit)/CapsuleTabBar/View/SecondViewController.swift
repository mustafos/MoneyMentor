//
//  SecondViewController.swift
//  CapsuleTabBar
//
//  Created by Mustafa Bekirov on 05.03.2024.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SecondViewController: TabBarConfigurable {
    var tabBarIcon: UIImage? {
        return UIImage(named: "create")
    }
    
    var tabBarSelectedIcon: UIImage? {
        return UIImage(named: "createSelect")
    }
    
    var tabBarTitle: String {
        return "Create"
    }
}

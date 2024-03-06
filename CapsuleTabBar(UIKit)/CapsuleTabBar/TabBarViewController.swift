//
//  TabBarViewController.swift
//  CapsuleTabBar
//
//  Created by Mustafa Bekirov on 05.03.2024.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    // MARK: – Properties
    private let createTab = CapsuleTabBarModel(
        index: 0,
        icon: FirstViewController().tabBarIcon?.withTintColor(.black, renderingMode: .alwaysOriginal),
        selectedIcon: FirstViewController().tabBarSelectedIcon?.withRenderingMode(.alwaysOriginal),
        viewController: FirstViewController())
    
    private let contentTab = CapsuleTabBarModel(
        index: 1,
        icon: SecondViewController().tabBarIcon?.withTintColor(.black, renderingMode: .alwaysOriginal),
        selectedIcon: SecondViewController().tabBarSelectedIcon?.withRenderingMode(.alwaysOriginal),
        viewController: SecondViewController())
    
    private let seedsTab = CapsuleTabBarModel(
        index: 2,
        icon: ThirdViewController().tabBarIcon?.withTintColor(.black, renderingMode: .alwaysOriginal),
        selectedIcon: ThirdViewController().tabBarSelectedIcon?.withRenderingMode(.alwaysOriginal),
        viewController: ThirdViewController())
    
    private let serverTab = CapsuleTabBarModel(
        index: 3,
        icon: FourthViewController().tabBarIcon?.withTintColor(.black, renderingMode: .alwaysOriginal),
        selectedIcon: FourthViewController().tabBarSelectedIcon?.withRenderingMode(.alwaysOriginal),
        viewController: FourthViewController())
    
    private lazy var tabBarTabs: [CapsuleTabBarModel] = [createTab, contentTab, seedsTab, serverTab]
    
    private var customTabBar: CapsuleTabBar!
    
    // MARK: – Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomTabBar()
        setupConstraints()
        setupProperties()
        view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: – Methods
    
    private func setupCustomTabBar() {
        self.customTabBar = CapsuleTabBar(tabBarTabs: tabBarTabs, onTabSelected: { [weak self] index in
            self?.selectTabWith(index: index)
        })
    }
    
    private func setupConstraints() {
        view.addSubview(customTabBar)
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        if UIDevice().userInterfaceIdiom == .pad {
            NSLayoutConstraint.activate([
                customTabBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
                customTabBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
                customTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -18),
                customTabBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                customTabBar.heightAnchor.constraint(equalToConstant: 76)
            ])
        } else {
            NSLayoutConstraint.activate([
                customTabBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
                customTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -21),
                customTabBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
                customTabBar.heightAnchor.constraint(equalToConstant: 76)
            ])
        }
    }
    
    private func setupProperties() {
        tabBar.isHidden = true
        customTabBar.layer.shadowColor = UIColor.black.cgColor
        customTabBar.layer.shadowOffset = .zero
        customTabBar.layer.shadowOpacity = 0.4
        customTabBar.layer.shadowRadius = 7
        
        self.selectedIndex = 0
        let controllers = tabBarTabs.map { item in
            return item.viewController
        }
        self.setViewControllers(controllers, animated: true)
    }
    
    private func selectTabWith(index: Int) {
        self.selectedIndex = index
    }
}

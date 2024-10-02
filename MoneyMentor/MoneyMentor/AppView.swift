//
//  AppTabBarView.swift
//  MoneyMentor
//
//  Created by Mustafa Bekirov on 02.10.2024.
//

import SwiftUI

struct AppView: View {
    @EnvironmentObject var balanceManager: BalanceManager
    @State private var selectedTab: Tab = .earnings
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack {
            VStack {
                TabView(selection: $selectedTab) {
                    ForEach(Tab.allCases, id: \.rawValue) { tab in
                        contentView(for: tab)
                            .tag(tab)
                            .environmentObject(balanceManager)
                    }
                }
            }
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
    
    // Function to return different views for each tab
    @ViewBuilder
    private func contentView(for tab: Tab) -> some View {
        switch tab {
        case .investing:
            InvestingView()
        case .business:
            BusinessView()
        case .earnings:
            EarningsView()
        case .items:
            ItemsView()
        case .profile:
            ProfileView()
        }
    }
}


import SwiftUI

enum Tab: String, CaseIterable {
    case investing
    case business
    case earnings
    case items
    case profile
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    
    private func iconImage(for tab: Tab) -> String {
        switch tab {
        case .investing:
            return "distribute.horizontal.center"
        case .business:
            return "building.2"
        case .earnings:
            return "dollarsign.bank.building"
        case .items:
            return "rectangle.3.group"
        case .profile:
            return "person"
        }
    }
    
    private func fillImage(for tab: Tab) -> String {
        return iconImage(for: tab) + ".fill"
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    Image(systemName: selectedTab == tab ? fillImage(for: tab) : iconImage(for: tab))
                        .scaleEffect(tab == selectedTab ? 1.25 : 1.0)
                        .foregroundStyle(selectedTab == tab ? .accent : .gray)
                        .font(.system(size: 22))
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                selectedTab = tab
                            }
                        }
                    Spacer()
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 5)
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
        }
    }
}

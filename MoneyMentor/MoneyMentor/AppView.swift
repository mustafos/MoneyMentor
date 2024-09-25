//
//  AppTabBarView.swift
//  MoneyMentor
//
//  Created by Mustafa Bekirov on 02.10.2024.
//

import SwiftUI

struct AppView: View {
    @State private var selectedTab: Tab = .earnings
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack {
            VStack {
                TabView(selection: $selectedTab) {
                    ForEach(Tab.allCases, id: \.rawValue) { tab in
                        contentView(for: tab).tag(tab)
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
//            InvestingView()
            ContentView()
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
    
    private var tabColor: Color {
        switch selectedTab {
        case .investing:
            return .pink
        case .business:
            return .teal
        case .earnings:
            return .cyan
        case .items:
            return .indigo
        case .profile:
            return .mint
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    Image(systemName: selectedTab == tab ? fillImage(for: tab) : iconImage(for: tab))
                        .scaleEffect(tab == selectedTab ? 1.25 : 1.0)
                        .foregroundStyle(selectedTab == tab ? tabColor : .gray)
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

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            // Top card view for balance
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.8))
                    .frame(width: 350, height: 180)
                    .shadow(radius: 10)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "creditcard.fill")
                            .foregroundColor(.yellow)
                        Text("**** **** **** 1234")
                            .foregroundColor(.white)
                    }
                    .padding(.top, 10)
                    
                    Text("Balance:")
                        .foregroundColor(.white)
                        .font(.body)
                    
                    Text("$ 6,641,485,902.02")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Text("05/26")
                            .foregroundColor(.white)
                    }
                }
                .padding()
            }
            .padding(.top, 20)
            
            // Earnings button area
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.green.opacity(0.6)]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: 350, height: 80)
                    .shadow(radius: 5)
                
                Text("$ 240.00 per click")
                    .foregroundColor(.white)
                    .font(.title2)
            }
            .padding(.vertical, 20)
            
            // Ad section
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.green.opacity(0.3))
                    .frame(width: 350, height: 60)
                    .shadow(radius: 5)
                
                HStack {
                    Image(systemName: "play.rectangle.fill")
                        .foregroundColor(.black)
                    
                    Text("Ad")
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text("$ 1,557.60 per click")
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text("For 30 sec.")
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 20)
            
            // Click icon
            Spacer()
            
            VStack {
                Image(systemName: "hand.point.up.left.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.gray)
                
                Text("Click in this area to earn money")
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Bottom navigation bar
            HStack {
                Spacer()
                VStack {
                    Image(systemName: "chart.bar.fill")
                        .foregroundColor(.gray)
                    Text("Investing")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                VStack {
                    Image(systemName: "building.2.fill")
                        .foregroundColor(.gray)
                    Text("Business")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                VStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.blue)
                    Text("Earnings")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                VStack {
                    Image(systemName: "square.grid.2x2.fill")
                        .foregroundColor(.gray)
                    Text("Items")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                VStack {
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(.gray)
                    Text("Profile")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding(.bottom, 20)
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.green.opacity(0.3)]), startPoint: .top, endPoint: .bottom))
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  CapsuleTabBar.swift
//  CapsuleTabBar
//
//  Created by Mustafa Bekirov on 28.02.2024.
//

import SwiftUI

enum TabBar: String, CaseIterable {
    case hazardsign
    case house
    case graduationcap
}

struct CapsuleTabBar: View {
    @Binding var selectedTab: TabBar
    @EnvironmentObject var model: Model
    private var fillImage: String {
            selectedTab.rawValue + ".fill"
        }
    private func getText(for tab: TabBar) -> String {
        switch tab {
        case .hazardsign:
            return "Značky"
        case .house:
            return "Hlavní"
        case .graduationcap:
            return "eTesty"
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(TabBar.allCases, id: \.rawValue) { tab in
                    Spacer()
                    ZStack {
                        Button {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                selectedTab = tab
                            }
                        } label: {
                            HStack {
                                Image(systemName: tab == selectedTab ? fillImage : tab.rawValue)
                                    .scaleEffect(tab == selectedTab ? 1.25 : 1.0)
                                    .foregroundStyle(tab == selectedTab ? .app : .secondary)
                                    .font(.system(size: tab == selectedTab ? 20 : 24))
                                if selectedTab == tab {
                                    Text(getText(for: tab))
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                        .foregroundStyle(.app)
                                }
                            }
                        }
                    }
                    .opacity(selectedTab == tab ? 1 : 0.7)
                    .padding()
                    .background(selectedTab == tab ? .accent : .clear)
                    .clipShape(Capsule())
                    
                    Spacer()
                }
            }
            .frame(width: nil, height: 76)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
            .shadow(color: .secondary, radius: 10)
            .padding()
        }
        .opacity(model.showTab ? 1.0 : 0.0)
    }
}

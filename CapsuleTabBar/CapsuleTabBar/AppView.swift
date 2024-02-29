//
//  AppView.swift
//  CapsuleTabBar
//
//  Created by Mustafa Bekirov on 28.02.2024.
//

import SwiftUI

class Model: ObservableObject { @Published var showTab: Bool = true }

struct AppView: View {
    @State private var selectedTab: TabBar = .house
    @State private var selectedDate = Date()
    @EnvironmentObject var model: Model
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack {
            VStack {
                TabView(selection: $selectedTab) {
                    ForEach(TabBar.allCases, id: \.rawValue) { tab in
                        Group {
                                switch tab {
                                case .hazardsign:
                                    LocationView()
                                case .house:
                                    LocationView()
                                case .graduationcap:
                                    LocationView()
                                }
                        }
                        .tag(tab)
                    }
                }
            }
            
            VStack {
                Spacer()
                CapsuleTabBar(selectedTab: $selectedTab)
            }
            .padding(.bottom, 10)
            .ignoresSafeArea()
        }
        .onAppear {
            model.showTab = true
        }
    }
}

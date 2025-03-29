//
//  InvestingView.swift
//  MoneyMentor
//
//  Created by Mustafa Bekirov on 02.10.2024.
//

import SwiftUI

struct InvestingView: View {
    @State private var currentTask: String = "Shares"
    var categoriesData = ["Shares", "Real Estate", "Crypto"]
    
    var body: some View {
        VStack {
            Text("Investing")
            CategoryView(categories: categoriesData, action: { value in
                currentTask = value
            })
            ProductCardView(title: currentTask.capitalized, subtitle: "About", image: "asas")
        }
    }
}

#Preview {
    InvestingView()
}

import SwiftUI

struct CategoryView: View {
    var categories: [String]
    @State private var selectedCategory: Int = 0
    var action: (String) -> ()
    
    var body: some View {
        VStack(alignment: .center) {
            GeometryReader { geo in
                VStack {
                    HStack(spacing: 10) {
                        ForEach(0..<categories.count, id: \.self) { i in
                            Spacer()
                            CategoryItem(isSelected: i == selectedCategory, title: categories[i])
                                .onTapGesture {
                                    selectedCategory = i
                                    action(categories[i])
                                }
                            Spacer()
                        }
                    }
                }
                .frame(width: geo.size.width)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct CategoryItem: View {
    var isSelected: Bool = false
    var title: String = "Shares"
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .kerning(1)
                .multilineTextAlignment(.center)
                .foregroundStyle(isSelected ? .yellow : .gray.opacity(0.9))
                .bold(isSelected)
            
            if isSelected {
                Capsule()
                    .foregroundStyle(.yellow)
                    .frame(maxWidth: .infinity)
                    .frame(height: 3)
                    .animation(.easeInOut(duration: 1), value: isSelected)
            }
        }
    }
}

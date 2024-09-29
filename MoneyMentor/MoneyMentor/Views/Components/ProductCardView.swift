//
//  ProductCardView.swift
//  MoneyMentor
//
//  Created by Mustafa Bekirov on 10.10.2024.
//

import SwiftUI

struct ProductCardView: View {
    let title: String
    let subtitle: String
    let image: String
    
    var body: some View {
        VStack {
            Text(title)
            Text(subtitle)
            Image(image)
        }.foregroundStyle(.white)
    }
}

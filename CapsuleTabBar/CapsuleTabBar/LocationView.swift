//
//  LocationView.swift
//  CapsuleTabBar
//
//  Created by Mustafa Bekirov on 28.02.2024.
//

import SwiftUI

struct LocationView: View {
    @EnvironmentObject var model: Model
    var body: some View {
        Button {
            model.showTab.toggle()
        } label: {
            HStack {
                Text("Location")
                Image(systemName: "location")
            }
        }

    }
}

#Preview {
    LocationView()
}

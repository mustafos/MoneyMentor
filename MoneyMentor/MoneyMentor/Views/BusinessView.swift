//
//  BusinessView.swift
//  MoneyMentor
//
//  Created by Mustafa Bekirov on 02.10.2024.
//

import SwiftUI

struct BusinessView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Business")
            VStack {
                Text("$ 3.173,902,526.85")
                Text("Total income per hour")
            }
            .padding()
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            HStack {
                Button {
                    // start new business
                } label: {
                    Text("Start a business")
                }
                
                Button {
                    // mergers
                } label: {
                    Text("Business mergers")
                }
            }
            
            Text("My Companies")
            ScrollView(.vertical, showsIndicators: false) {
                HStack {
                    VStack {
                        HStack {
                            Circle()
                                .fill(.secondary)
                                .frame(width: 40)
                            VStack {
                                Text("Company Name")
                                Text("Company Type")
                            }
                        }
                        
                        Text("$ 139,234,145.00")
                        + Text("per hour")
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.forward.circle")
                }
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                //
                Text("Limit of businesses - 10")
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
    }
}

#Preview {
    BusinessView()
}

//
//  ProfileView.swift
//  MoneyMentor
//
//  Created by Mustafa Bekirov on 02.10.2024.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var balanceManager: BalanceManager
    
    var body: some View {
        VStack {
            headerComponent
            
            ScrollView(.vertical, showsIndicators: false) {
                fortuneContainer
                
                vehiclesBlock
                
                VStack(alignment: .leading) {
                    Text("Activities")
                    Text("""
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
""")
                }
                .padding()
                .background(.eliteTeal.gradient.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(maxWidth: .infinity)
                
                Button {
                    withAnimation(.snappy) {
                        HapticFeedback.playSelection()
                        balanceManager.resetProgress()
                    }
                } label: {
                    Text("Progress reset")
                        .font(.system(.subheadline, design: .rounded, weight: .bold))
                        .foregroundStyle(.black)
                        .padding()
                        .background(Color.secondary)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                
                infoBlock
            }
        }.padding()
    }
}

private extension ProfileView {
    var headerComponent: some View {
        HStack {
            Text("Profile")
            Spacer()
            Circle()
                .fill(.accent)
                .frame(width: 40)
        }
    }
    
    var fortuneContainer: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Fortune")
            Text("$ 1.8 T")
            Capsule()
                .fill(.accent)
                .frame(maxWidth: .infinity, maxHeight: 20)
            balancePosition(color: .red, title: "Balance", balance: "$ 25.0 B")
            balancePosition(color: .red, title: "Balance", balance: "$ 25.0 B")
            balancePosition(color: .red, title: "Balance", balance: "$ 25.0 B")
            balancePosition(color: .red, title: "Balance", balance: "$ 25.0 B")
            balancePosition(color: .red, title: "Balance", balance: "$ 25.0 B")
            
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    @ViewBuilder
    func balancePosition(color: Color, title: String, balance: String) -> some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 12)
            Text(title)
            Spacer()
            Text(balance)
        }
    }
    
    var vehiclesBlock: some View {
        VStack {
            Text("Primary vehicles")
            HStack {
                Image(systemName: "car")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120)
                Spacer()
                Image(systemName: "airplane")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120)
            }.padding(.horizontal)
        }
    }
    
    var infoBlock: some View {
        HStack {
            Button {
                // info block
            } label: {
                Text("Information")
                    .font(.system(.subheadline, design: .rounded, weight: .bold))
                    .foregroundStyle(.black)
                    .padding()
                    .background(Color.secondary)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            
            Button {
                // info block
            } label: {
                Text("Information")
                    .font(.system(.subheadline, design: .rounded, weight: .bold))
                    .foregroundStyle(.black)
                    .padding()
                    .background(Color.secondary)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        .padding(.bottom, 60)
    }
}

#Preview {
    ProfileView()
}

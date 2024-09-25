//
//  EarningsView.swift
//  MoneyMentor
//
//  Created by Mustafa Bekirov on 02.10.2024.
//

import SwiftUI

struct EarningsView: View {
    @State var time = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var count = 50
    @State var level = 50
    @State var buttonP = 0
    @State var showAlert = false
    @State var title = ""
    
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.green.opacity(0.3)]), startPoint: .top, endPoint: .bottom))
                .frame(maxWidth: .infinity, maxHeight: 325)
                .ignoresSafeArea()
            VStack {
                cardView
                Text("$ 240.00")
                    .font(.largeTitle).bold().foregroundStyle(.white)
                + Text(" pre click").font(.footnote).foregroundStyle(.white.opacity(0.8))
                
                HStack(spacing: 16) {
                        VStack {
                            Image(systemName: "play.rectangle")
                            Text("Ad")
                        }
                        Capsule()
                            .frame(width: 2, height: 50)
                            .foregroundStyle(.secondary)
                        HStack {
                            Image(systemName: "dollarsign.arrow.trianglehead.counterclockwise.rotate.90")
                            VStack(alignment: .leading) {
                                Text("$ 1,500.00")
                                    .font(.subheadline).bold()
                                + Text(" pre click").font(.footnote).foregroundStyle(.black.opacity(0.8))
                                Text("for 30 sec.")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.green.opacity(0.6)]), startPoint: .leading, endPoint: .trailing))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("\(count)").font(.title).foregroundStyle(.white)
                Spacer()
                Button {
                    addPress()
                } label: {
                    VStack {
                        Image(systemName: "hand.tap")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60)
                            .foregroundColor(.gray)
                        Text("\(buttonP)")
                        Text("Click in this area to earn money")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.white)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(title), message: Text("Reset or Move to Next Level"), primaryButton: .default(Text("Reset"), action: {
                        rest()
                    }), secondaryButton: .default(Text("Next Level!"), action: {
                        next()
                    }))
                }
                Spacer()
            }.padding()
        }
        //        .onReceive(time) { (_) in
        //            minusNum()
        //        }
    }
    
    func addPress() {
        buttonP += 1
    }
    
    func minusNum() {
        if count != 0 {
            count -= 1
        } else {
            if buttonP > level / 2 {
                title = "You Won!"
                showAlert = true
            } else {
                title = "You Lost!"
                showAlert = true
            }
        }
    }
    
    func rest() {
        count = 50
        buttonP = 0
        showAlert = false
    }
    
    func next() {
        buttonP = 0
        level += 10
        count = level
        showAlert = false
    }
}

extension EarningsView {
    var cardView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Balance")
                    .font(.headline)
                    .padding(.bottom)
                
                Spacer()
                // MastercardLogo
                ZStack {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 46)
                        .offset(x: -12)
                        .blendMode(.multiply)
                    
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 46)
                        .offset(x: 12)
                        .blendMode(.multiply)
                }.compositingGroup()
            }
            
            Spacer(minLength: 8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("$17,370.52")
                    .font(.system(.title, design: .monospaced, weight: .heavy))
                Text("Expiry by 29 May, 2024")
                    .font(.subheadline)
                    .opacity(0.8)
            }
            .padding(.bottom)
            HStack {
                Text("**** **** **** 3022")
                Spacer()
                Text("05/24")
            }
            .font(.headline)
                .fontDesign(.monospaced)
        }
        .font(.title3)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: 150)
        .padding(20)
        .background(.linearGradient(colors: [.teal, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
    }
}

#Preview {
    EarningsView()
}

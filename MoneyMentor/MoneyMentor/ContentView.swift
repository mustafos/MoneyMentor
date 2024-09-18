//
//  ContentView.swift
//  MoneyMentor
//
//  Created by Mustafa Bekirov on 23.09.2024.
//

import SwiftUI

struct ContentView: View {
    @State var time = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var count = 50
    @State var level = 50
    @State var buttonP = 0
    @State var showAlert = false
    @State var title = ""
    
    var body: some View {
        ZStack {
            Color.purple.ignoresSafeArea()
            VStack {
                Text("Press The Button")
                    .font(.largeTitle).bold().foregroundStyle(.white)
                Text("\(count)").font(.title).foregroundStyle(.white)
                Spacer()
                Button {
                    addPress()
                } label: {
                    Text("\(buttonP)")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .frame(width: 150, height: 150)
                        .background(.red)
                        .clipShape(Circle())
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
        }.onReceive(time) { (_) in
            minusNum()
        }
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

#Preview {
    ContentView()
}

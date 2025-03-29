//
//  EarningsView.swift
//  MoneyMentor
//
//  Created by Mustafa Bekirov on 02.10.2024.
//

import SwiftUI

struct EarningsView: View {
    @EnvironmentObject private var balanceManager: BalanceManager
    
    @State var time = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var count = 50
    @State var level = 50
    @State var buttonP = 0
    @State var showAlert = false
    @State var title = ""
    
    // New state variables for tap animation
    @State private var tapLocation: CGPoint = .zero
    @State private var showTapAnimation = false
    @State private var animationOffset: CGFloat = 0 // Смещение для анимации вверх
    @State private var animationOpacity: Double = 1.0 // Прозрачность текста
    
    @State private var showRewardedAds: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Color("EliteTealColor")
                .ignoresSafeArea()
                .coordinateSpace(name: "tapArea") // Указываем пространство координат
                .onTapGesture { location in
                    // Захват местоположения касания и запуск анимации
                    let tapLocationInView = locationInView(location: location)
                    tapLocation = tapLocationInView
                    animationOffset = 0 // Сбрасываем смещение
                    animationOpacity = 1.0 // Сбрасываем прозрачность
                    showTapAnimation = true
                    withAnimation(.snappy) {
                        animationOffset = -100 // Смещаем вверх на 50
                        animationOpacity = 0.0 // Постепенно исчезаем
                    }
                    addPress()
                    balanceManager.earnMoneyClick()
                }
            
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.green.opacity(0.3)]), startPoint: .top, endPoint: .bottom))
                .frame(maxWidth: .infinity, maxHeight: 325)
                .ignoresSafeArea()
            
            VStack {
                cardView
                VStack {
                    Text("$ \(balanceManager.correctFormatted(balanceManager.pricePerClick))")
                        .font(.system(.largeTitle, design: .monospaced, weight: .bold))
                    + Text(" pre click").font(.footnote)
                    + Text(" ––> ").font(.footnote)
                    + Text("$ \(balanceManager.correctFormatted(balanceManager.pricePerClick * 2))")
                        .font(.system(.subheadline, design: .monospaced, weight: .bold))
                        .foregroundColor(.accentColor)
                    
                    Button {
                        // Level Up logic
                    } label: {
                        Text("Raise the level ($ 540.7k)")
                            .font(.system(.subheadline, design: .rounded, weight: .bold))
                            .foregroundStyle(.eliteTeal)
                            .padding()
                            .background(Color.accent)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(maxWidth: .infinity)
                .shadow(radius: 2)
                
                Text("\(count)")
                
                rewardedAdButton
                
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
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(title), message: Text("Reset or Move to Next Level"), primaryButton: .default(Text("Reset"), action: {
                        rest()
                    }), secondaryButton: .default(Text("Next Level!"), action: {
                        next()
                    }))
                }
                Spacer()
            }
        }
        //                .onReceive(time) { (_) in
        //                    minusNum()
        //                }
        
        // Animated tap feedback
        .overlay(
            // Анимация отображения текста на месте касания
            Group {
                if showTapAnimation {
                    Image(systemName: "dollarsign")
                        .imageScale(.medium)
                        .foregroundStyle(.white)
                        .position(tapLocation)
                        .offset(y: animationOffset) // Смещаем текст вверх
                        .opacity(animationOpacity) // Меняем прозрачность
                }
            }
        )
        .onAppear {
            withAnimation {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    showRewardedAds.toggle()
                }
            }
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
    
    // Функция для получения координат касания внутри вью
    func locationInView(location: CGPoint) -> CGPoint {
        // Если нужно использовать сложные расчеты или обработку координат
        // Здесь мы можем вернуть те же координаты для простоты
        return location
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
                Text("$ \(balanceManager.correctFormatted(balanceManager.currentBalance))")
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
            .font(.system(.headline, design: .monospaced, weight: .regular))
        }
        .font(.title3)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: 150)
        .padding(20)
        .background(.linearGradient(colors: [.teal, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
        .padding(.horizontal)
    }
    
    var rewardedAdButton: some View {
        Button {
            // TODO: Show Rewarded Ads
            balanceManager.costUpPerClick()
        } label: {
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
                        + Text(" pre click")
                            .font(.footnote)
                        Text("for 30 sec.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.green.opacity(0.6)]), startPoint: .leading, endPoint: .trailing))
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .buttonStyle(.plain)
        .padding(.top, -10)
        .animation(.easeInOut(duration: 1.5), value: showRewardedAds)
        .opacity($showRewardedAds.wrappedValue ? 1 : 0)
        .offset(y: $showRewardedAds.wrappedValue ? 0 : -100)
    }
}

#Preview {
    EarningsView()
}

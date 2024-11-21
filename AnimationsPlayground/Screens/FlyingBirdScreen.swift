//
//  FlyingBirdScreen.swift
//  AnimationsPlayground
//
//  Created by Fernando Draghi on 20/11/2024.
//

import SwiftUI

struct FlyingBirdScreen: View {
    @State private var leftWingAnimating = false
    @State private var rightWingAnimating = false
    @State private var bodyAnimating = false
    @State private var shadowAnimating = false
    
    var body: some View {
        VStack {
            ZStack {
                Image("leftWing")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(leftWingAnimating ? -100 : 0), anchor: .bottomTrailing)
                    .offset(x: -55, y: leftWingAnimating ? -190 : 0)
                    .shadow(color: .teal, radius: 1, x:0, y:3)
                    .animation(.easeInOut(duration: 1).repeatForever(), value: leftWingAnimating)
                    .shadow(color: .teal, radius: shadowAnimating ? 40 : 4, x:0, y:shadowAnimating ? 40 : 1)
                Image("rightWing")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(rightWingAnimating ? 100 : 0), anchor: .bottomLeading)
                    .offset(x: 55, y: rightWingAnimating ? -190 : 0)
                    .shadow(color: .teal, radius: 1, x:0, y:3)
                    .animation(.easeInOut(duration: 1).repeatForever(), value: rightWingAnimating)
                    .shadow(color: .teal, radius: shadowAnimating ? 40 : 4, x:0, y:shadowAnimating ? 40 : 1)
                Image("body")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .offset(y: bodyAnimating ? -70 : 30)
                    .shadow(color: .white, radius: 1, x:0, y:3)
                    .animation(.easeInOut(duration: 1).repeatForever(), value: bodyAnimating)
                    .shadow(color: .yellow.opacity(0.5), radius: shadowAnimating ? 20 : 0, x:0, y:shadowAnimating ? 40 : 0)
            }
            .padding(.top, 130)
            .shadow(color: .white, radius: shadowAnimating ? 40 : 4, x:0, y:shadowAnimating ? 40 : 1)
            .animation(.easeInOut(duration: 1).repeatForever(), value: shadowAnimating)
            .onAppear() {
                leftWingAnimating.toggle()
                rightWingAnimating.toggle()
                bodyAnimating.toggle()
                shadowAnimating.toggle()
            }
            Spacer()
        }
        .navigationTitle("Flying Bird")
        .preferredColorScheme(.dark)
    }
}

#Preview {
    NavigationStack {
        FlyingBirdScreen()
    }
}

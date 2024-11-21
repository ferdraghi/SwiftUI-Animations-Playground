//
//  CirclesScreen.swift
//  AnimationsPlayground
//
//  Created by Fernando Draghi on 19/11/2024.
//

import SwiftUI

struct CirclesScreen: View {
    @State private var scaleInOut = false
    @State private var rotateInOut = false
    @State private var moveInOut = false
    
    var body: some View {
        VStack {
            ZStack {
                Circles(animationValue: $moveInOut)
                .opacity(0.5)
                Circles(animationValue: $moveInOut)
                .rotationEffect(.degrees(60))
                .opacity(0.5)
                Circles(animationValue: $moveInOut)
                .rotationEffect(.degrees(120))
                .opacity(0.5)
            }
            .rotationEffect(.degrees(rotateInOut ? 180 : 0))
            .scaleEffect(scaleInOut ? 1 : 1/2)
            .animation(.easeInOut.repeatForever().speed(1/8) , value: moveInOut)
            .ignoresSafeArea()
            .padding(.bottom, 150)
        }
        .onAppear() {
            withAnimation {
                moveInOut.toggle()
                scaleInOut.toggle()
                rotateInOut.toggle()
            }
        }
        .navigationTitle("Circles Animation")
        
    }
}

struct Circles: View {
    @Binding var animationValue: Bool
    var size: CGFloat = 120
    var travelDistance: CGFloat = 55
    
    var body: some View {
        ZStack {
            Circle().fill(LinearGradient(gradient: Gradient(colors:[.teal, .clear]),
                                         startPoint: .top,
                                         endPoint: .bottom))
            .frame(width: size, height: size)
            .offset(y: animationValue ? -travelDistance : 0)
            Circle().fill(LinearGradient(gradient: Gradient(colors:[.teal, .clear]),
                                         startPoint: .bottom,
                                         endPoint: .top))
            .frame(width: size, height: size)
            .offset(y: animationValue ? travelDistance : 0)
        }
    }
}

#Preview {
    NavigationStack {
        CirclesScreen()
    }
}

#Preview {
    Circles(animationValue: .constant(true))
}

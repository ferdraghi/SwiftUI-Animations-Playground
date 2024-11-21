//
//  BreathingFlowersScreen.swift
//  AnimationsPlayground
//
//  Created by Fernando Draghi on 20/11/2024.
//

import SwiftUI

struct BreathingFlowersScreen: View {
    @State private var petal = false
    @State private var breatheIn = true
    @State private var breatheOut = false
    @State private var offsetBreathe = false
    @State private var diffuseBreathe = false
    @State private var breatheBouquet = false
    @State private var offsetSnow = false
    
    var body: some View {
        GeometryReader { g in
            ZStack(alignment: .center) {
                Image("winterNight")
                    .resizable()
                    .scaledToFill()
                ZStack {
                    Group {
                        Text("Breathe In")
                            .font(.custom("Helvetica", size: 35))
                            .foregroundStyle(.green)
                            .opacity(breatheIn ? 0 : 1)
                            .scaleEffect(breatheIn ? 0 : 1)
                            .offset(y: -160)
                            .animation(.easeInOut(duration: 2).delay(2).repeatForever(), value: breatheIn)
                        Text("Breathe Out")
                            .font(.custom("Helvetica", size: 35))
                            .foregroundStyle(.orange)
                            .opacity(breatheOut ? 0 : 1)
                            .scaleEffect(breatheOut ? 0 : 1)
                            .offset(y: -160)
                            .animation(.easeInOut(duration: 2).delay(2).repeatForever(), value: breatheOut)
                    }
                    
                    Group {
                        Image("smoke")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 35, height: 125)
                            .offset(y: offsetBreathe ? 90 : -g.size.height / 3)
                            .animation(.easeInOut(duration: 2).delay(2).repeatForever(), value: offsetBreathe)
                            .blur(radius: diffuseBreathe ? 1 : 125)
                            .animation(.easeInOut(duration: 2).delay(2).repeatForever(), value: diffuseBreathe)
                    }.shadow(radius: diffuseBreathe ? 20 : 0)
                    
                    Group {
                        BreathingFlowersPetalsView(animating: $petal, degrees: petal ? -25 : -5)
                        BreathingFlowersPetalsView(animating: .constant(false), degrees: 0.0)
                        BreathingFlowersPetalsView(animating: $petal, degrees: petal ? 25 : 5)
                        BreathingFlowersPetalsView(animating: $petal, degrees: petal ? -50 : -10)
                        BreathingFlowersPetalsView(animating: $petal, degrees: petal ? 50 : 10)
                    }
                    
                    Group {
                        Image("bouquet")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 400)
                            .rotationEffect(.degrees(37))
                            .offset(x:-25, y:90)
                            .scaleEffect(breatheBouquet ? 1.04 : 1, anchor: .center)
                            .animation(.easeInOut(duration: 2).delay(2).repeatForever(), value: breatheBouquet)
                        Image("bouquet")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 400)
                            .rotationEffect(.degrees(37))
                            .offset(x:-20, y:95)
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                            .scaleEffect(breatheBouquet ? 1.02 : 1, anchor: .center)
                            .animation(.easeInOut(duration: 2).delay(2).repeatForever(), value: breatheBouquet)
                    }
                    
                    Group {
                        BreathingFlowersSnowView()
                            .offset(x: offsetSnow ? 50 : 0)
                            .animation(.easeInOut(duration: 15).repeatForever(), value: offsetSnow)
                    }
                }
            }
            .onAppear() {
                breatheIn.toggle()
                breatheOut.toggle()
                offsetBreathe.toggle()
                diffuseBreathe.toggle()
                petal.toggle()
                breatheBouquet.toggle()
                offsetSnow.toggle()
            }
            .frame(width: g.size.width, height: g.size.height)
        }
        .ignoresSafeArea()
        .navigationTitle("Breathing Flowers")
    }
}

#Preview {
    BreathingFlowersScreen()
}

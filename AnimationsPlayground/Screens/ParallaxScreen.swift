//
//  ParallaxScreen.swift
//  AnimationsPlayground
//
//  Created by Fernando Draghi on 21/11/2024.
//

import SwiftUI

struct ParallaxScreen: View {
    @State private var animation1 = false
    @State private var animation2 = false
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    ZStack {
                        Image("wolf")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                            .clipShape(.rect(cornerRadius: 25))
                            .shadow(color: .mint, radius: 50, x: 5, y: 5)
                            .rotation3DEffect(.degrees(animation1 ? 13 : -13),
                                              axis: (x: animation1 ? -90 : -45,
                                                     y: animation1 ? -45 : -90,
                                                     z: animation1 ? -30 : -85),
                                              anchorZ: 50)
                        Image("wolf")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                            .clipShape(.rect(cornerRadius: 25))
                            .opacity(0.25)
                            .rotation3DEffect(.degrees(animation1 ? 13 : -13),
                                              axis: (x: animation1 ? -90 : -45,
                                                     y: animation1 ? -45 : -90,
                                                     z: animation1 ? -30 : -85),
                                              anchorZ: 20)
                        Image("wolf")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                            .clipShape(.rect(cornerRadius: 25))
                            .opacity(0.25)
                            .rotation3DEffect(.degrees(animation1 ? 13 : -13),
                                              axis: (x: animation1 ? -90 : -45,
                                                     y: animation1 ? -45 : -90,
                                                     z: animation1 ? -30 : -85),
                                              anchorZ: -10)
                        Image("wolf")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                            .clipShape(.rect(cornerRadius: 25))
                            .opacity(0.25)
                            .rotation3DEffect(.degrees(animation1 ? 13 : -13),
                                              axis: (x: animation1 ? -90 : -45,
                                                     y: animation1 ? -45 : -90,
                                                     z: animation1 ? -30 : -85),
                                              anchorZ: -40)
                    }
                    .animation(.easeInOut(duration: 3.5).repeatForever(), value: animation1)
                    Spacer(minLength: 30)
                    VStack {
                        ZStack {
                            Image("cube")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200)
                                .clipShape(.rect(cornerRadius: 25))
                                .shadow(color: .mint, radius: 60, x: 5, y: 5)
                                .rotation3DEffect(.degrees(animation2 ? 18 : -18),
                                                  axis: (x: animation2 ? -90 : -45,
                                                         y: animation2 ? -45 : -90,
                                                         z: animation1 ? 85 : -30),
                                                  anchorZ: 50)
                            Image("cube")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200)
                                .clipShape(.rect(cornerRadius: 25))
                                .opacity(0.25)
                                .rotation3DEffect(.degrees(animation2 ? 18 : -18),
                                                  axis: (x: animation2 ? -90 : -45,
                                                         y: animation2 ? -45 : -90,
                                                         z: animation1 ? 85 : -30),
                                                  anchorZ: 20)
                            Image("cube")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200)
                                .clipShape(.rect(cornerRadius: 25))
                                .opacity(0.25)
                                .rotation3DEffect(.degrees(animation2 ? 18 : -18),
                                                  axis: (x: animation2 ? -90 : -45,
                                                         y: animation2 ? -45 : -90,
                                                         z: animation1 ? 85 : -30),
                                                  anchorZ: -10)
                            Image("cube")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200)
                                .clipShape(.rect(cornerRadius: 25))
                                .opacity(0.25)
                                .rotation3DEffect(.degrees(animation2 ? 18 : -18),
                                                  axis: (x: animation2 ? -90 : -45,
                                                         y: animation2 ? -45 : -90,
                                                         z: animation1 ? 85 : -30),
                                                  anchorZ: -40)
                        }
                    }
                    .animation(.easeInOut(duration: 4).repeatForever(), value: animation2)
                    Spacer()
                }
                Spacer()
            }
        }
        .onAppear() {
            animation1.toggle()
            animation2.toggle()
        }
        .navigationTitle("Parallax Effect")
        .preferredColorScheme(.dark)
    }
}

#Preview {
    NavigationStack {
        ParallaxScreen()
    }
}

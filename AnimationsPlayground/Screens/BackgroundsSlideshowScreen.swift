//
//  Untitled.swift
//  AnimationsPlayground
//
//  Created by Fernando Draghi on 21/11/2024.
//

import SwiftUI

struct BackgroundsSlideshowScreen: View {
    let imageNames = Array(1...13).map{"img\($0)"}
    
    @State private var currentBkg = 0
    @State private var hueAnimation = false
    private let timer = Timer.publish(every: 5, on: .main, in: .default).autoconnect()
    
    var body: some View {
        GeometryReader { g in
            VStack {
                ZStack {
                    TabView(selection: $currentBkg) {
                        ForEach(imageNames.indices, id:\.self) { index in
                            Image(imageNames[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: g.size.width, height: g.size.height)
                                .tag(index)
                        }
                    }
                    .hueRotation(.degrees(hueAnimation ? 720 : 0))
                    .padding(.bottom, 0)
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .animation(.easeInOut(duration:1), value: currentBkg)
                    .animation(.linear(duration: 5).repeatForever(), value: hueAnimation)
                }
            }
        }
        .onReceive(timer) { _ in
            currentBkg = (currentBkg + 1) % max(imageNames.count, 1)
        }
        .onAppear() {
            hueAnimation.toggle()
        }
        .navigationTitle("Background Slideshow")
    }
}

#Preview {
    BackgroundsSlideshowScreen()
}

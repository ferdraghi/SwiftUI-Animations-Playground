//
//  Untitled.swift
//  AnimationsPlayground
//
//  Created by Fernando Draghi on 21/11/2024.
//

import SwiftUI

struct BackgroundsSlideshowScreen: View {
    @State private var currentBkg = 0
    @State private var loadTabView = false
    @State private var hueAnimation = false
    private let imageNames = Array(1...13).map{"img\($0)"}
    
    private let timer = Timer.publish(every: 5, on: .main, in: .default).autoconnect()
    
    var body: some View {
        VStack {
            TabView(selection: $currentBkg) {
                ForEach(imageNames.indices, id:\.self) { index in
                    Image(imageNames[index])
                        .resizable()
                        .scaledToFill()
                        .tag(index)
                }
            }
            .tabViewStyle(.page)
            .hueRotation(.degrees(hueAnimation ? 720 : 0))
            .padding(.bottom, 0)
            .animation(.easeInOut(duration:1), value: currentBkg)
            .animation(.linear(duration: 5).repeatForever(), value: hueAnimation)
        }
        .padding(.top, 20)
        .onReceive(timer) { _ in
            currentBkg = (currentBkg + 1) % max(imageNames.count, 1)
        }
        .onAppear() {
            loadTabView = true
            hueAnimation.toggle()
        }
        .navigationTitle("Background Slideshow")
    }
}

#Preview {
    BackgroundsSlideshowScreen()
}

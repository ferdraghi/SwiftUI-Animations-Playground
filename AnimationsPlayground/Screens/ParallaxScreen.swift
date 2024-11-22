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
                    
                    ParallaxScreenImageStackView(imageName: "wolf",
                                                 animating: $animation1,
                                                 animatingAngleDegrees: (13, -13),
                                                 animatingAxis:
                                                    (.init(x: -90, y: -45, z: -30),
                                                     .init(x: -45, y: -90, z: -85)))
                    .animation(.easeInOut(duration: 3.5).repeatForever(), value: animation1)
                    
                    Spacer(minLength: 30)
                    
                    ParallaxScreenImageStackView(imageName: "cube",
                                                 animating: $animation2,
                                                 animatingAngleDegrees: (18, -18),
                                                 animatingAxis:
                                                    (.init(x: -90, y: -45, z: 85),
                                                     .init(x: -45, y: -90, z: -30)))
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

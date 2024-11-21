//
//  BallPitScreen.swift
//  AnimationsPlayground
//
//  Created by Fernando Draghi on 21/11/2024.
//

import SwiftUI
import SpriteKit

struct BallPitScreen: View {
    var scene: SKScene {
        let scene = BallPitScene()
        let screenSize = UIScreen.main.bounds.size
        scene.size = CGSize(width: screenSize.width, height: screenSize.height)
        return scene
    }
    
    var body: some View {
        GeometryReader { g in
            HStack {
                Spacer()
                VStack(alignment: .center) {
                    SpriteView(scene: scene)
                        .frame(width: 320, height: 620)
                    Text("Touch and drag!")
                        .padding(.top, 10)
                }
                Spacer()
            }
            .padding(.top, 180)
            .navigationTitle("Ball Pit")
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    NavigationStack {
        BallPitScreen()
    }
}

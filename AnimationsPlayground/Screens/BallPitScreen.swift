//
//  BallPitScreen.swift
//  AnimationsPlayground
//
//  Created by Fernando Draghi on 21/11/2024.
//

import SwiftUI
import SpriteKit

class BallPitScene: SKScene {
    private var currentTouchLocation: CGPoint?
    private var currentTouchDate: Date?
    override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        let location = touch.location(in: self)
        currentTouchLocation = location
        currentTouchDate = .now
        addBall(on: location)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard
            let currentLocation = currentTouchLocation,
            let currentDate = currentTouchDate,
            Date.now.timeIntervalSince(currentDate) > 0.001,
            let touch = touches.first
        else { return }

        let location = touch.location(in: self)
        let deltaX = location.x - currentLocation.x
        let deltaY = location.y - currentLocation.y
        let distance = sqrt(deltaX * deltaX + deltaY * deltaY)
        if distance > 1 {
            addBall(on: location)
            currentTouchLocation = location
            currentTouchDate = .now
        }
    }
    
    private func addBall(on location: CGPoint) {
        let ball = SKSpriteNode(imageNamed: "dodgeBall")
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.7)
        ball.physicsBody?.restitution = 0.4
        ball.position = location
        addChild(ball)
    }
}

struct BallPitScreen: View {
    var scene: SKScene {
        let scene = BallPitScene()
        let screenSize = UIScreen.main.bounds.size
        scene.size = CGSize(width: screenSize.width, height: screenSize.height)
        return scene
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.teal, .teal, .white, .white, .yellow, .white, .white, .teal, .teal,]), startPoint: .top, endPoint: .bottom)
            VStack {
                SpriteView(scene: scene)
                    .frame(width: 320, height: 650)
                    .opacity(0.5)
            }
        }
        .navigationTitle("Ball Pit")
        .ignoresSafeArea()
    }
}

#Preview {
    NavigationStack {
        BallPitScreen()
    }
}

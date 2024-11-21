//
//  BallPitScene.swift
//  AnimationsPlayground
//
//  Created by Fernando Draghi on 21/11/2024.
//

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

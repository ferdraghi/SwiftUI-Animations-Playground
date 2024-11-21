//
//  BreathingFlowersSnowView.swift
//  AnimationsPlayground
//
//  Created by Fernando Draghi on 20/11/2024.
//

import SwiftUI

struct BreathingFlowersSnowView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        let screen = UIScreen.main.bounds
        let view = UIView(frame: CGRect(x: 0,
                                        y: 0,
                                        width: screen.width,
                                        height: screen.height))
        view.layer.masksToBounds = true
        
        let emitter = CAEmitterLayer()
        emitter.frame = CGRect(x: screen.midX,
                               y: -200,
                               width: screen.size.width,
                               height: screen.size.height)
        emitter.emitterShape = .rectangle
        emitter.renderMode = .backToFront
        emitter.emitterMode = .volume
        let near = makeEmmiterCell(color: UIColor(white: 1, alpha: 1), velocity: 25, scale: 0.03)
        let middle = makeEmmiterCell(color: UIColor(white: 1, alpha: 0.66), velocity: 20, scale: 0.025)
        let far = makeEmmiterCell(color: UIColor(white: 1, alpha: 0.33), velocity: 18, scale: 0.02)
        
        emitter.emitterCells = [near, middle, far]
        view.layer.addSublayer(emitter)
        
        return view
    }
    
    private func makeEmmiterCell(color:UIColor, velocity:CGFloat, scale:CGFloat)-> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 35
        cell.lifetime = 80.0
        cell.lifetimeRange = 0
        cell.velocity = velocity
        cell.velocityRange = velocity / 4
        cell.emissionLongitude = .pi
        cell.emissionRange = .pi
        cell.scale = scale
        cell.scaleRange = scale / 3
        cell.contents = UIImage(named: "snow")?.cgImage

        cell.alphaRange = Float(color.cgColor.components![1] * 10)
        cell.alphaSpeed = -0.05
        return cell
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

#Preview {
    BreathingFlowersSnowView()
}

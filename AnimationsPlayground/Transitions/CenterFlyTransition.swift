//
//  CenterFlyTransition.swift
//  AnimationsPlayground
//
//  Created by Fernando Draghi on 21/11/2024.
//

import SwiftUI

struct CenterFlyTransition: GeometryEffect {
    func effectValue(size: CGSize) -> ProjectionTransform {
        let rotationOffset = offsetValue
        let angleOfRotation = CGFloat(Angle(degrees: 95 * (1 - rotationOffset)).radians)
        
        var transform3d = CATransform3DIdentity
        transform3d.m34 = -1 / max(size.width, size.height)
        
        transform3d = CATransform3DRotate(transform3d, angleOfRotation, 1, 0, 0)
        transform3d = CATransform3DTranslate(transform3d, -size.width / 2.0, -size.height / 2.0, 0)
        
        let transformAffine1 = ProjectionTransform(CGAffineTransform(translationX: size.width / 2.0, y: size.height / 2.0))
        let transformAffine2 = ProjectionTransform(CGAffineTransform(scaleX: CGFloat(offsetValue * 2.0), y: CGFloat(offsetValue * 2.0)))
        
        if offsetValue <= 0.5 {
            return ProjectionTransform(transform3d).concatenating(transformAffine2).concatenating(transformAffine1)
        } else {
            return ProjectionTransform(transform3d).concatenating(transformAffine1)
        }

    }
    
    var offsetValue: Double
    
    var animatableData: Double {
        get { offsetValue }
        set { offsetValue = newValue }
    }
}

extension AnyTransition {
    static var fly: AnyTransition {
        AnyTransition.modifier(active: CenterFlyTransition(offsetValue: 0.001), identity: CenterFlyTransition(offsetValue: 1))
    }
}

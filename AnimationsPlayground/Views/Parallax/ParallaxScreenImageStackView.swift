//
//  ParallaxScreenImageStackView.swift
//  AnimationsPlayground
//
//  Created by Fernando Draghi on 21/11/2024.
//

import SwiftUI

struct ParallaxImageStackAxis {
    var x: CGFloat
    var y: CGFloat
    var z: CGFloat
}

struct ParallaxScreenImageStackView: View {
    var imageName: String = ""
    @Binding var animating: Bool
    var animatingAngleDegrees: (Double, Double) = (0, 0)
    var animatingAxis: (ParallaxImageStackAxis, ParallaxImageStackAxis) = (.init(x: 0, y: 0, z: 0), .init(x: 0, y: 0, z: 0))
    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                .clipShape(.rect(cornerRadius: 25))
                .shadow(color: .mint, radius: 50, x: 5, y: 5)
                .rotation3DEffect(.degrees(animating ? animatingAngleDegrees.0 : animatingAngleDegrees.1),
                                  axis: (x: animating ? animatingAxis.0.x : animatingAxis.1.x,
                                         y: animating ? animatingAxis.0.y : animatingAxis.1.y,
                                         z: animating ? animatingAxis.0.z : animatingAxis.1.z),
                                  anchorZ: 50)
            ForEach(1..<4) { i in
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                        .clipShape(.rect(cornerRadius: 25))
                        .opacity(0.25)
                        .rotation3DEffect(.degrees(animating ? animatingAngleDegrees.0 : animatingAngleDegrees.1),
                                          axis: (x: animating ? animatingAxis.0.x : animatingAxis.1.x,
                                                 y: animating ? animatingAxis.0.y : animatingAxis.1.y,
                                                 z: animating ? animatingAxis.0.z : animatingAxis.1.z),
                                          anchorZ: 50 - CGFloat((30 * i)))
            }
        }
    }
}

#Preview {
    ParallaxScreenImageStackView(imageName: "wolf", animating: .constant(true))
}

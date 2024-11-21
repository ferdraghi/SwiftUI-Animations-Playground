//
//  CirclesScreenCirclesView.swift
//  AnimationsPlayground
//
//  Created by Fernando Draghi on 21/11/2024.
//
import SwiftUI

struct CirclesScreenCirclesView: View {
    @Binding var animationValue: Bool
    var size: CGFloat = 120
    var travelDistance: CGFloat = 55
    
    var body: some View {
        ZStack {
            Circle().fill(LinearGradient(gradient: Gradient(colors:[.teal, .clear]),
                                         startPoint: .top,
                                         endPoint: .bottom))
            .frame(width: size, height: size)
            .offset(y: animationValue ? -travelDistance : 0)
            Circle().fill(LinearGradient(gradient: Gradient(colors:[.teal, .clear]),
                                         startPoint: .bottom,
                                         endPoint: .top))
            .frame(width: size, height: size)
            .offset(y: animationValue ? travelDistance : 0)
        }
    }
}

#Preview {
    CirclesScreenCirclesView(animationValue: .constant(true))
}

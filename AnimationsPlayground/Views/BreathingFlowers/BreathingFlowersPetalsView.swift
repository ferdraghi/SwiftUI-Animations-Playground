//
//  BreathingFlowersPetalsView.swift
//  AnimationsPlayground
//
//  Created by Fernando Draghi on 20/11/2024.
//

import SwiftUI

struct BreathingFlowersPetalsView: View {
    @Binding var animating: Bool
    
    var degrees = 0.0

    var body: some View {
        Image("petal")
            .resizable()
            .scaledToFit()
            .frame(height: 125)
            .rotationEffect(.degrees(animating ? degrees : 0), anchor: .bottom)
            .animation(.easeInOut(duration: 2).delay(2).repeatForever(), value: animating)
    }
}

#Preview {
    BreathingFlowersPetalsView(animating: .constant(true), degrees: 25)
}

//
//  ContentView.swift
//  AnimationsPlayground
//
//  Created by Fernando Draghi on 19/11/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        List {
            NavigationLink(destination: CirclesScreen()) {
                listButtonLabel("Circles")
            }
            NavigationLink(destination: RecordPlayerScreen()) {
                listButtonLabel("Record Player")
            }
            NavigationLink(destination: HueRotationScreen()) {
                listButtonLabel("HUE Rotation")
            }
            NavigationLink(destination: BreathingFlowersScreen()) {
                listButtonLabel("Breathing Flowers")
            }
            NavigationLink(destination: FlyingBirdScreen()) {
                listButtonLabel("Flying Bird")
            }
            NavigationLink(destination: BallPitScreen()) {
                listButtonLabel("Ball Pit")
            }
            NavigationLink(destination: BackgroundsSlideshowScreen()) {
                listButtonLabel("Background Slideshow")
            }
            NavigationLink(destination: CustomTransitionScreen()) {
                listButtonLabel("Custom Transitions")
            }
            NavigationLink(destination: ParallaxScreen()) {
                listButtonLabel("Parallax Effect")
            }
        }
        .navigationTitle("Animations Playground")
    }
    
    private func listButtonLabel(_ title: String) -> some View {
        HStack(alignment: .center) {
            Text(title)
                .font(.title2)
                .padding(.leading, 20)
            Spacer()
        }
        .frame(height: 40)
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}

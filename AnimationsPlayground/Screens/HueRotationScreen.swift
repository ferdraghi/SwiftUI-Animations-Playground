//
//  HueRotationScreen.swift
//  AnimationsPlayground
//
//  Created by Fernando Draghi on 20/11/2024.
//

import SwiftUI

struct HueRotationScreen: View {
    @State private var shiftColors = false
    @State private var imageName = "dog"

    var body: some View {
        VStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .hueRotation(.degrees(shiftColors ? 720 : 0))
                    .animation(.linear(duration: 2).repeatForever(autoreverses: true), value: shiftColors)
            }
            HueRotationImagePickerView(selectedImageName: $imageName)
            
        }
        .onAppear() {
            shiftColors.toggle()
        }
        .navigationTitle("HUE Rotation")
        .preferredColorScheme(.dark)
    }
}

#Preview {
    HueRotationScreen()
}

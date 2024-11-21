//
//  CustomTransitionScreen.swift
//  AnimationsPlayground
//
//  Created by Fernando Draghi on 21/11/2024.
//

import SwiftUI

struct CustomTransitionScreen: View {
    @State private var showSettings = false
    
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    Text("Wake Up")
                        .font(.title)
                    Image(systemName: "clock")
                        .font(.largeTitle)
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showSettings.toggle()
                        }
                    } label: {
                        Image(systemName: "gear")
                            .font(.system(size: 40).weight(.bold))
                            .foregroundStyle(.mint)
                    }
                    .padding(.top, 80)
                }
                if showSettings {
                    CustomTransitionsSettingsView(show: $showSettings)
                        .transition(.fly)
                        .zIndex(1)
                }
            }
        }
    }
}

#Preview {
    CustomTransitionScreen()
}

//
//  RecordPlayer.swift
//  AnimationsPlayground
//
//  Created by Fernando Draghi on 19/11/2024.
//

import SwiftUI

enum RecordPlayerState {
    case stopped
    case starting
    case playing
    case stopping
}

struct RecordPlayerScreen: View {
    @State private var play: Bool = false
    
    var body: some View {
        VStack {
            RecordPlayer(play: $play)
                .padding(.top, 40)
            Button {
                play.toggle()
            } label: {
                HStack(spacing: 8) {
                    Text(play ? "Stop " : "Play ")
                        .bold()
                        .font(.title2)
                        .foregroundStyle(.white)
                    Image(systemName: play ? "stop.fill" : "play.circle.fill")
                        .foregroundStyle(.white)
                        .imageScale(.large)
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(Capsule().strokeBorder(.white, lineWidth: 2))
                
            }
            .padding(.top, 40)
            Spacer()
        }
        .navigationTitle("Record Player")
        .preferredColorScheme(.dark)
    }
}

#Preview {
    NavigationStack {
        RecordPlayerScreen()
    }
}

//
//  RecordPlayer.swift
//  AnimationsPlayground
//
//  Created by Fernando Draghi on 19/11/2024.
//

import SwiftUI

struct RecordPlayerScreen: View {
    @State private var isPlaying = false
    @State private var isStopping = false
    
    var body: some View {
        VStack {
            Text("This screen is broken as of now.")
                .font(.title)
                .multilineTextAlignment(.leading)
            RecordPlayer(isPlaying: $isPlaying, isStopping: $isStopping)
                .padding(.top, 40)
            Button {
                isPlaying.toggle()
                isStopping = !isPlaying
            } label: {
                HStack(spacing: 8) {
                    Text(isPlaying ? "Stop " : "Play ")
                        .bold()
                        .font(.title2)
                        .foregroundStyle(.white)
                    Image(systemName: isPlaying ? "stop.fill" : "play.circle.fill")
                        .foregroundStyle(.white)
                        .imageScale(.large)
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(Capsule().strokeBorder(.white, lineWidth: 2))
                
            }
            .padding(.top, 80)
            Spacer()
        }
        .navigationTitle("Record Player")
    }
}

struct AnimationValues {
    var rotation = Angle(degrees: 0)
}

struct PlayerArmAnimationValues {
    var rotation = Angle(degrees: -35)
    var scale = 1.0
}

struct RecordPlayer: View {
    @Binding var isPlaying: Bool
    @Binding var isStopping: Bool
    
    private var armPosition: Double {
        if isStopping {
            return -27
        }
        
        return -35
    }
    
    private var armTargetPosition: Double {
        if isPlaying {
            return -27
        }
        
        return -35
    }
    
    var body: some View {
        VStack {
            ZStack {
                Image("woodGrain")
                    .resizable()
                    .frame(width: 320, height: 320)
                    .border(.black, width: 10)
                    .clipShape(.rect(cornerRadius: 10))
                    .shadow(color: .white, radius: 10)
                Image("record")
                    .resizable()
                    .frame(width: 280, height: 280)
                    .keyframeAnimator(initialValue: AnimationValues(),
                                      repeating: isPlaying,
                                      content: { view, value in
                        view
                            .rotationEffect(value.rotation)
                    }, keyframes: { _ in
                        KeyframeTrack(\.rotation) {
                            LinearKeyframe(Angle(degrees: 360), duration: 1.0)
                        }
                    })
                    .padding([.bottom, .trailing], 20)
                    .shadow(color: .black, radius: 8, x: 5, y: 5)
                Image("playerArm")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .keyframeAnimator(initialValue: PlayerArmAnimationValues(rotation: Angle(degrees: armPosition)),
                                      trigger: isPlaying,
                                      content: { view, values in
                        view
                            .rotationEffect(values.rotation, anchor: .topTrailing)
                            .scaleEffect(values.scale, anchor: .topTrailing)
                    }, keyframes: { _ in
                        KeyframeTrack(\.scale) {
                            LinearKeyframe(1.05, duration: 1.0, timingCurve: .easeInOut)
                            LinearKeyframe(1.05, duration: 3.0, timingCurve: .linear)
                            LinearKeyframe(1.0, duration: 1.0, timingCurve: .easeInOut)
                        }
                        
                        KeyframeTrack(\.rotation) {
                            LinearKeyframe(Angle(degrees: armPosition), duration: 1.0)
                            LinearKeyframe(Angle(degrees: armTargetPosition), duration: 3.0, timingCurve: .easeInOut)
                        }
                    })
                    .padding(.leading, 130)
                    .padding(.bottom, 90)
                    .shadow(color: .black, radius: 5, x: 2, y: 2)
            }
            .frame(width: 345, height: 345)
        }
    }
}

#Preview {
    NavigationStack {
        RecordPlayerScreen()
    }
}

extension Animation {
    func `repeat`(while expression: Bool, autoreverses: Bool = true) -> Animation {
        if expression {
            return self.repeatForever(autoreverses: autoreverses)
        } else {
            return self
        }
    }
}

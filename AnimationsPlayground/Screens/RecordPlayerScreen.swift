//
//  RecordPlayer.swift
//  AnimationsPlayground
//
//  Created by Fernando Draghi on 19/11/2024.
//

import SwiftUI
import AVKit

enum RecordPlayerState {
    case stopped
    case starting
    case playing
    case stopping
}

struct RecordPlayerScreen: View {
    @State private var state: RecordPlayerState = .stopped
    @State private var audioPlayer: AVAudioPlayer?
    
    private var songDuration: Double {
        audioPlayer?.duration ?? 0
    }
    
    private var currentTime: Double {
        audioPlayer?.currentTime ?? 0
    }
    
    private var isPlaying: Bool {
        state == .starting || state == .playing
    }
    
    var body: some View {
        VStack {
            Text("This screen is broken as of now.")
                .font(.title)
                .multilineTextAlignment(.leading)
            RecordPlayer(state: $state, player: $audioPlayer)
                .padding(.top, 40)
            Button {
                if state == .stopped ||
                    state == .stopping {
                    state = .starting
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        state = .playing
                        audioPlayer?.play()
                    }
                } else {
                    state = .stopping
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        audioPlayer?.stop()
                        audioPlayer?.currentTime = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        state = .stopped
                    }
                }
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
            .disabled(state == .starting || state == .stopping)
            .padding(.top, 80)
            Spacer()
        }
        .onAppear() {
            loadMusic()
        }
        .navigationTitle("Record Player")
    }
    
    private func loadMusic() {
        guard let fileUrl = Bundle.main.path(forResource: "music", ofType: "m4a") else {
            print("Audio file not found!")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(filePath: fileUrl))

            audioPlayer?.numberOfLoops = 1
        } catch {
            print("Audioplayer failed: \(error)")
        }
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
    @Binding var state: RecordPlayerState
    @Binding var player: AVAudioPlayer?
    
    private var rampUpRotations: Double {
        360 * 5
    }
    
    private var armPosition: Double {
        switch state {
        case .playing, .stopping:
            return -27
        default:
            return -35
        }
    }
    
    private var armTargetPosition: Double {
        switch state {
        case .starting, .playing:
            return -27
        default:
            return -35
        }
    }
    
    private var duration: Double {
        player?.duration ?? 0
    }
    
    private var currentTime: Double {
        player?.currentTime ?? 0
    }
    
    private var rotationDegrees: Double {
        switch state {
        case .starting:
            return rampUpRotations
        case .playing:
            return (360 * duration) + rampUpRotations
        case .stopping:
            return ((360 * currentTime) + rampUpRotations * 2)
        case .stopped:
            return 0
        }
    }
    private var animation: Animation {
        switch state {
        case .starting:
            return .easeIn(duration: 5.1)
        case .playing:
            return .linear(duration: 120)
        case .stopping:
            return .easeOut(duration: 5)
        case .stopped:
            return .linear(duration: 0)
        }
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
                VStack{
                    Image("record")
                        .resizable()
                        .frame(width: 280, height: 280)
                        .rotationEffect(.degrees(rotationDegrees))
                }
                .animation(animation, value: state)
                .padding([.bottom, .trailing], 20)
                .shadow(color: .black, radius: 8, x: 5, y: 5)
                Image("playerArm")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .keyframeAnimator(initialValue: PlayerArmAnimationValues(rotation: Angle(degrees: armPosition)),
                                      trigger: state,
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

//
//  RecordPlayer.swift
//  AnimationsPlayground
//
//  Created by Fernando Draghi on 19/11/2024.
//

import SwiftUI
import AVKit
import Combine

enum RecordPlayerState {
    case stopped
    case starting
    case playing
    case stopping
}

struct RecordPlayerScreen: View {
    @State private var state: RecordPlayerState = .stopped
    @State private var audioPlayer: AVAudioPlayer?
    @State private var play: Bool = false
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
            RecordPlayer(state: $state, player: $audioPlayer, play: $play)
                .padding(.top, 40)
            Button {
                play.toggle()
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
            .opacity((state == .starting || state == .stopping) ? 0.3 : 1)
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
            //audioPlayer?.volume = 0.1
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
    @Binding var play: Bool
    
    @State private var timer: AnyCancellable?
    @State private var currentRotationDegrees: CGFloat = 0.0
    @State private var speed: CGFloat = 0.0

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

    private var armPlayingAnimation: Animation {
        switch state {
        case .playing:
                .linear(duration: duration)
        default:
                .linear(duration: 0)
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
                Image("record")
                    .resizable()
                    .frame(width: 280, height: 280)
                    .rotationEffect(.degrees(currentRotationDegrees))
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
                            LinearKeyframe((state == .starting || state == .stopping) ?  1.05 : 1.0, duration: 1.0, timingCurve: .easeInOut)
                            LinearKeyframe((state == .starting || state == .stopping) ?  1.05 : 1.0, duration: 3.0, timingCurve: .linear)
                            LinearKeyframe(1.0, duration: 1.0, timingCurve: .easeIn)
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
        .onChange(of: play, { oldValue, newValue in
            if newValue {
                startTimer()
            }
        })
        .onChange(of: state) { oldValue, newValue in
            if newValue == .stopped {
                timer?.cancel()
                timer = nil
            }
        }
    }
    
    private func startTimer() {
        timer?.cancel()
        timer = nil
        timer = Timer
            .publish(every: 1/60,
                     on: .main,
                     in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                if play {
                    speed = min(speed + 0.05, 10.0)
                } else {
                    speed = max(speed - 0.05, 0.0)
                }
                if currentRotationDegrees > 360 {
                    currentRotationDegrees -= 360
                }
                withAnimation {
                    currentRotationDegrees += speed
                }
            }
    }
}

#Preview {
    NavigationStack {
        RecordPlayerScreen()
    }
}

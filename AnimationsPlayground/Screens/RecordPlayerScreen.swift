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

struct AnimationValues {
    var rotation = Angle(degrees: 0)
}

struct PlayerArmAnimationValues {
    var rotation = Angle(degrees: -35)
    var scale = 1.0
}

struct RecordPlayer: View {
    @Binding var play: Bool
    @State private var player: AVAudioPlayer? = nil
    @State private var state: RecordPlayerState = .stopped
    
    @State private var timer: AnyCancellable?
    @State private var stateChangeTimer: Timer?
    
    // Record Properties
    @State private var currentRotationDegrees: CGFloat = 0.0
    @State private var speed: CGFloat = 0.0
    // Arm Properties
    @State private var armScale = 1.0
    @State private var armDegrees = -35.0
    @State private var elapsedTime = 0.0
    @State private var armRotationSpeed = 0.0
    
    private let armScaleStep = 0.05 / 60.0
    private let armRotationStep = 23.0 / 120.0
    private let armRotationSpeedAcceleration = (23.0 / 120.0) / 120.0
    private let timeToStartStop = 5.0
    @State private var armPlaybackSpeed = 0.0
    @State private var songPlaybackCountdown = 0.0
    // arm parking: -35, record start: -27, record end: -12
    
    private var duration: Double {
        player?.duration ?? 0
    }
    
    private var currentTime: Double {
        player?.currentTime ?? 0
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
                    .rotationEffect(.degrees(armDegrees), anchor: .topTrailing)
                    .scaleEffect(armScale, anchor: .topTrailing)
                    .padding(.leading, 130)
                    .padding(.bottom, 90)
                    .shadow(color: .black, radius: 5, x: 2, y: 2)
            }
            .frame(width: 345, height: 345)
            Text("Playback Arm Position: \(String(format: "%.2f", armDegrees))")
                .font(.system(size: 18))
                .monospacedDigit()
                .padding(.top, 30)
            Text("Playback Arm Scale: \(String(format: "%.2f", armScale))")
                .font(.system(size: 18))
                .monospacedDigit()
                .padding(.top, 10)
            Text("Song Remaining: \(String(format: "%.2f", songPlaybackCountdown))")
                .font(.system(size: 18))
                .monospacedDigit()
                .padding(.top, 10)
        }
        .onChange(of: play, { oldValue, newValue in
            if newValue {
                startPlayback()
            } else {
                stopPlayback()
            }
        })
        .onChange(of: state) { oldValue, newValue in
            if newValue == .starting {
                startTimer()
            }
            if newValue == .stopped {
                timer?.cancel()
                timer = nil
            }
        }
        .onAppear() {
            loadMusic()
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
                switch state {
                case .starting:
                    elapsedTime += 1/60
                    if elapsedTime < 1.0 {
                        armScale = min(armScale + armScaleStep, 1.05)
                    } else if elapsedTime < 4.0 {
                        armRotationSpeed = min(armRotationSpeed + armRotationSpeedAcceleration, armRotationStep)
                        armDegrees = min(armDegrees + armRotationSpeed, -27)
                    } else {
                        armScale = max(armScale - armScaleStep, 1.0)
                    }
                    speed = min(speed + 0.05, 10.0)
                case .playing:
                    speed = min(speed + 0.05, 10.0)
                    armDegrees = min(armDegrees + armPlaybackSpeed, -12)
                    songPlaybackCountdown -= 1/60
                    if songPlaybackCountdown <= 0 {
                        stopPlayback()
                    }
                case .stopping:
                    elapsedTime += 1/60
                    if elapsedTime < 1.0 {
                        armScale = min(armScale + armScaleStep, 1.05)
                    } else if elapsedTime < 4.0 {
                        armRotationSpeed = min(armRotationSpeed + armRotationSpeedAcceleration, armRotationStep)
                        armDegrees = max(armDegrees - armRotationSpeed, -35)
                    } else {
                        armScale = max(armScale - armScaleStep, 1.0)
                    }
                    speed = max(speed - 0.05, 0.0)
                case .stopped:
                    speed = 0
                }
                
                // Modulus operation not available here... So...
                if currentRotationDegrees > 360 {
                    currentRotationDegrees -= 360
                }
                
                withAnimation {
                    currentRotationDegrees += speed
                }
            }
    }
    
    private func startPlayback() {
        guard state == .stopping || state == .stopped else { return }
        stateChangeTimer?.invalidate()
        stateChangeTimer = nil
        state = .starting
        elapsedTime = 0
        armRotationSpeed = 0
        songPlaybackCountdown = player?.duration ?? 0.0
        stateChangeTimer = Timer
            .scheduledTimer(withTimeInterval: timeToStartStop, repeats: false, block: { _ in
                state = .playing
                player?.play()
            })
    }
    
    private func stopPlayback() {
        guard state == .playing || state == .starting else { return }
        stateChangeTimer?.invalidate()
        stateChangeTimer = nil
        state = .stopping
        player?.stop()
        player?.currentTime = 0
        elapsedTime = 0
        armRotationSpeed = 0
        play = false
        stateChangeTimer = Timer
            .scheduledTimer(withTimeInterval: timeToStartStop, repeats: false, block: { _ in
                state = .stopped
            })
    }
    
    private func loadMusic() {
        guard let fileUrl = Bundle.main.path(forResource: "music", ofType: "m4a") else {
            print("Audio file not found!")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: URL(filePath: fileUrl))
            
            player?.numberOfLoops = 0
            
            let songDuration = player?.duration ?? 1.0
            armPlaybackSpeed = (15.0 / songDuration) / 60.0
        } catch {
            print("Audioplayer failed: \(error)")
        }
    }
}

#Preview {
    NavigationStack {
        RecordPlayerScreen()
    }
}

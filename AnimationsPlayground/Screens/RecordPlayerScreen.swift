//
//  RecordPlayer.swift
//  AnimationsPlayground
//
//  Created by Fernando Draghi on 19/11/2024.
//

import SwiftUI

enum AnimationState: Int, CaseIterable {
    case none = 0, starting, playing, ending
}

struct RecordAnimationValues {
    var some: Double = 0.0
    var angle: Angle = .degrees(0)
}

class RecordPlayerAnimationsObserver: ObservableObject {
    @Published private(set) var state: AnimationState = .none
    @Published private(set) var recordRotation = Angle.degrees(0)
    @Published private(set) var speed: CGFloat = 0.0
    private var playingWorkItem: DispatchWorkItem?
    private var stoppingWorkItem: DispatchWorkItem?
    
    func startPlaying() {
        withAnimation(.easeIn(duration: 3)) {
            state = .starting
            speed = 1.0
        } completion: { [weak self] in
            self?.state = .playing
        }
//        stoppingWorkItem?.cancel()
//        
//        playingWorkItem = DispatchWorkItem { [weak self] in
//            guard let self = self else { return }
//            self.state = .starting
//            withAnimation(.easeIn(duration: 1)) {
//                self.recordRotation = Angle.degrees(360)
//            } completion: {
//                self.state = .playing
//                withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
//                    self.recordRotation = Angle.degrees(720)
//                }
//            }
//        }
//        
//        playingWorkItem?.perform()
    }
    
    func stopPlaying() {
        withAnimation(.easeOut(duration: 1)) {
            state = .ending
            speed = 0.0
        } completion: { [weak self] in
            self?.state = .none
        }
//        playingWorkItem?.cancel()
//        
//        stoppingWorkItem = DispatchWorkItem { [weak self] in
//            guard let self = self else { return }
//            self.state = .ending
//            withAnimation(.easeOut(duration: 1)) {
//                self.recordRotation = Angle.degrees(360)
//            } completion: {
//                self.state = .none
//                self.recordRotation = Angle.degrees(0)
//            }
//        }
//        
//        stoppingWorkItem?.perform()
    }
}

struct RecordPlayerScreen: View {
    @State private var recordPlayerAnimationsObserver = RecordPlayerAnimationsObserver()
    @State private var isPlaying = false
    @State private var degrees = 0.0
    
    var body: some View {
        VStack {
            Text("This screen is broken as of now.")
                .font(.title)
                .multilineTextAlignment(.leading)
            RecordPlayer(animationsObserver: recordPlayerAnimationsObserver)
                .padding(.top, 40)
            Button {
                isPlaying.toggle()
                
                if isPlaying {
                    recordPlayerAnimationsObserver.startPlaying()
                } else {
                    recordPlayerAnimationsObserver.stopPlaying()
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
            .padding(.top, 80)
            Spacer()
        }
        .navigationTitle("Record Player")
    }
}

struct RecordPlayer: View {
    @ObservedObject var animationsObserver: RecordPlayerAnimationsObserver

    var body: some View {
        let _ = print("rebuilding: \(animationsObserver.state) - \(animationsObserver.recordRotation.degrees)")
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
                    .keyframeAnimator(
                        initialValue: RecordAnimationValues(),
                        trigger: animationsObserver.state, content: { content, value in
                        content
                                .rotationEffect(value.angle)
                    }, keyframes: { phase in
                        KeyframeTrack(\.angle) {
                            CubicKeyframe(Angle(degrees: 360), duration: 1, startVelocity: Angle(degrees: 0), endVelocity: Angle(degrees: 360))
                            LinearKeyframe(Angle(degrees: 3600), duration: 10.0)
                            CubicKeyframe(Angle(degrees: 0), duration: 1, startVelocity: Angle(degrees: 360), endVelocity: Angle(degrees: 0))
                        }
                        
//                        switch phase {
//                        case .starting:
//                                .easeInOut(duration: 1)
//                        case .playing:
//                                .linear(duration: 1).repeatForever(autoreverses: false)
//                        case .ending:
//                                .easeOut(duration: 1)
//                        case .none:
//                            nil
//                        }
                    })
                    
                    .padding([.bottom, .trailing], 20)
                    .shadow(color: .black, radius: 8, x: 5, y: 5)
                Image("playerArm")
                    .resizable()
                    .frame(width: 150, height: 150)
                    //.rotationEffect(.degrees(animationState == .playing ? -27 : -35), anchor: .topTrailing)
                   // .animation(.easeInOut(duration: 2).delay(1.5), value: animationState == .playing)
                    .padding(.leading, 130)
                    .padding(.bottom, 90)
                    .shadow(color: .black, radius: 5, x: 2, y: 2)
            }
            //.animation(.linear.speed(animationsObserver.speed).repeatForever(autoreverses: false), value: true)
            .frame(width: 345, height: 345)
        }
    }
    
    private var rotations: Angle {
        switch animationsObserver.state {
        case .starting: return .degrees(360)
        case .playing: return .degrees(720)
        case .ending: return .degrees(1080)
        case .none: return .degrees(0)
        }
    }
}

#Preview {
    NavigationStack {
        RecordPlayerScreen()
    }
}

#Preview {
    RecordPlayer(animationsObserver: RecordPlayerAnimationsObserver())
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

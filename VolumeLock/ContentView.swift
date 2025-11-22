//
//  ContentView.swift
//  VolumeLock
//
//  Created by Shahzaib Ali on 22/11/2025.
//

import SwiftUI
import MediaPlayer
struct ContentView: View {
    @State private var volume: Double = 0.5
    @State private var volumeDetector: VolumeDetector? = nil
    @State private var isStarted : Bool = false
    var body: some View {
        VStack {
            
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            VStack(spacing: 16) {
                Text("Volume: \(Int(volume * 100))%")
                    .font(.headline)

                HStack(spacing: 24) {
                    Button(action: {
                        volume = max(0.0, volume - 0.1)
                        setSystemVolume(Float(volume))
                    }) {
                        Label("Decrease", systemImage: "speaker.wave.1")
                    }
                    .buttonStyle(.bordered)
                    Button(action: {
                        volume = min(1.0, volume + 0.1)
                        setSystemVolume(Float(volume))
                    }) {
                        Label("Increase", systemImage: "speaker.wave.3")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            Button(action: {
                isStarted.toggle()
            }) {
                Text(isStarted ? "Stop" : "Start")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .task {
            volumeDetector = VolumeDetector()
            volumeDetector?.onVolumeChange({ _ in
                if(isStarted){
//                    self.volume = Double(volume)
                    setSystemVolume(Float(volume))
                
                }
                
            })
        }
        .padding()
     
    }

    


    private let volumeView = MPVolumeView()

    func setSystemVolume(_ level: Float) {  // 0.0 to 1.0
        print("setSystemVolume Volume changed to: \(level)")
        let slider = volumeView.subviews.compactMap { $0 as? UISlider }.first
        slider?.setValue(level, animated: false)
    }

    func increaseVolume() {
        let current = AVAudioSession.sharedInstance().outputVolume
        setSystemVolume(min(current + 0.0625, 1.0))  // +1 step (16 steps total)
    }

    func decreaseVolume() {
        let current = AVAudioSession.sharedInstance().outputVolume
        setSystemVolume(max(current - 0.0625, 0.0))
    }
}

#Preview {
    ContentView()
}

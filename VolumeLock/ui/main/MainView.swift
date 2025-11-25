//
//  MainView.swift
//  VolumeLock
//
//  Created by Shahzaib Ali on 22/11/2025.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel: MainViewModel
    @State private var showDurationSheet = false
    @State private var showSettingsSheet = false
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [AppColors.backgroundGradientStart, AppColors.backgroundGradientEnd]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Settings Button Overlay
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showSettingsSheet = true
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.2))
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 50) // Adjust for safe area
                }
                Spacer()
            }
            // Main Content
            VStack(spacing: 30) {
                Spacer()
                
                // Start Button
                CircularStartButton(
                    isStarted: viewModel.isStarted,
                    timerText: viewModel.formattedRemainingTime
                ) {
                    viewModel.toggleStart()
                }
                .padding(.top, 40)
                
                Spacer()
                
                // Controls Container
                VStack(alignment: .leading, spacing: 25) {
                    
                    // Volume Control
                    ControlSection(title: "Volume Level", icon: "speaker.wave.3.fill", valueText: "\(Int(viewModel.volume * 100))%") {
                        Slider(value: Binding(
                            get: { viewModel.volume },
                            set: { viewModel.setVolume($0) }
                        ), in: 0...1)
                        .tint(AppColors.accent)
                    }
                    
                    // Brightness Control
                    ControlSection(title: "Screen Brightness", icon: "sun.max.fill", valueText: "\(Int(viewModel.brightness * 100))%") {
                        Slider(value: Binding(
                            get: { viewModel.brightness },
                            set: { viewModel.setBrightness($0) }
                        ), in: 0...1)
                        .tint(AppColors.controlTint)
                    }
                    
                    // Lock Duration
                    ControlSection(title: "Lock Duration", icon: "", valueText: "") {
                        Button(action: {
                            showDurationSheet = true
                        }) {
                            HStack {
                                Text(viewModel.lockDuration.rawValue)
                                    .foregroundColor(.black.opacity(0.7))
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.black.opacity(0.5))
                            }
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
        .sheet(isPresented: $showDurationSheet) {
            LockDurationSheet(viewModel: viewModel)
        }
        .sheet(isPresented: $showSettingsSheet) {
            SettingsSheet(viewModel: viewModel)
        }
    }
}

#Preview {
    // Mocking for preview
    let soundManager = SoundManagerImpl()
    let brightnessManager = BrightnessManagerImpl()
    let repository = MainRepository(soundManager: soundManager, brightnessManager: brightnessManager)
    let viewModel = MainViewModel(repository: repository)
    MainView(viewModel: viewModel)
}

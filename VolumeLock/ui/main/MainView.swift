//
//  MainView.swift
//  VolumeLock
//
//  Created by Shahzaib Ali on 22/11/2025.
//

import SwiftUI
import RevenueCatUI
struct MainView: View {
    @StateObject var viewModel: MainViewModel
    @StateObject var subscriptionMaanger : SubscriptionManager = SubscriptionManager.shared
    @State private var showDurationSheet = false
    @State private var showSettingsSheet = false
    @State private var displayPaywall = false
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
                    if(!viewModel.isStarted){
                        viewModel.alert.success(title: "Do Not Close the App", message: "For volume control to work correctly, keep the app running in the background.")
                        viewModel.showAlert{
                            viewModel.toggleStart()
                        }
                        return
                    }
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
//                    ControlSection(title: "Screen Brightness", icon: "sun.max.fill", valueText: "\(Int(viewModel.brightness * 100))%") {
//                        Slider(value: Binding(
//                            get: { viewModel.brightness },
//                            set: { viewModel.setBrightness($0) }
//                        ), in: 0...1)
//                        .tint(AppColors.controlTint)
//                    }
                    
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
                
                Text("For volume control to work correctly, keep the app running in the background.")
                    .font(.caption)
                    .foregroundColor(.red.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
            }
        }
        .sheet(isPresented: $displayPaywall) {
            PaywallView().onPurchaseCompleted { _ in
                showPurchaseSuccess()
            }
            .onRestoreCompleted({ _ in
                showPurchaseSuccess()
            })
            .onPurchaseFailure{ err in
                showPurchaseFailed(err:err)
            }
        }
        .sheet(isPresented: $showDurationSheet) {
            LockDurationSheet(isPremiumUser: subscriptionMaanger.isPremiumUser, viewModel: viewModel,onBuyPremium: {
                showDurationSheet = false
                displayPaywall = true
            })
        }
        .alert(
            viewModel.alert.title,
            isPresented: Binding(get: {
                viewModel.isAlertVisible
            }, set: { value in
                viewModel.hideAlert()
            }),
            actions: {
                Button(viewModel.alert.buttonText, role: viewModel.alert.isError ? .cancel : .confirm) {
                    viewModel.onClickAlert()
                    viewModel.hideAlert()
                    }
            },
            message: {
                Text(viewModel.alert.message)
            })
        .sheet(isPresented: $showSettingsSheet) {
            SettingsSheet(isPremiumUser: subscriptionMaanger.isPremiumUser, viewModel: viewModel,onBuyPremium: {
                self.showSettingsSheet = false
                displayPaywall = true
            })
        }
    }
    
    func showPurchaseFailed(err: NSError){
        self.displayPaywall = false
        viewModel.showAlert()
        viewModel.alert.error( title: "Purchase failed", message: err.localizedDescription  )
    }
    func showPurchaseSuccess(){
        subscriptionMaanger.isPremiumUser = true
        displayPaywall = false
        viewModel.showAlert()
        viewModel.alert .success(title: "Purchase successful", message: "Purchase successful! Enjoy your premium benefits.")
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

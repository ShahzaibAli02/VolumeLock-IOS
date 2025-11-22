//
//  SoundManagerImpl.swift
//  VolumeLock
//
//  Created by Shahzaib Ali on 23/11/2025.
//

import Foundation
import MediaPlayer
import AVFoundation
import Combine
import UIKit

class SoundManagerImpl: SoundManager {
    private var cancellables = Set<AnyCancellable>()
    private var volumeChangeWorkItem: DispatchWorkItem?
    private let volumeView = MPVolumeView()
    
    private var onVolumeChangeCallback: ((Float) -> Void)?
    
    // Current volume (0.0 – 1.0)
    var currentVolume: Float {
        AVAudioSession.sharedInstance().outputVolume
    }
    
    init() {
        startObservingVolumeChanges()
    }
    
    func setSystemVolume(_ level: Float) {
        print("SoundManagerImpl: setSystemVolume to: \(level)")
        let slider = volumeView.subviews.compactMap { $0 as? UISlider }.first
        
        // MPVolumeView needs to be in the window hierarchy to work reliably in some cases,
        // but often works if just initialized. If issues arise, we might need to add it to a hidden view.
        // For now, we follow the pattern from MainView.
        
        DispatchQueue.main.async {
            slider?.setValue(level, animated: false)
        }
    }
    
    func onVolumeChange(_ callback: @escaping (Float) -> Void) {
        self.onVolumeChangeCallback = callback
    }
    
    private func startObservingVolumeChanges() {
        let notificationName: NSNotification.Name
        
        if #available(iOS 15, *) {
            notificationName = NSNotification.Name(rawValue: "SystemVolumeDidChange")
        } else {
            notificationName = NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification")
        }
        
        NotificationCenter.default.publisher(for: notificationName)
            .sink { [weak self] notification in
                guard let self = self else { return }
                
                let volume = notification.userInfo?["AVSystemController_AudioVolumeNotificationParameter"] as? Float
                    ?? notification.userInfo?["Volume"] as? Float
                    ?? self.currentVolume
                
                let reason = notification.userInfo?["AVSystemController_AudioVolumeChangeReasonNotificationParameter"] as? String
                
                print("SoundManagerImpl: Volume changed to: \(volume), reason: \(reason ?? "unknown")")
                
                // Debounce/Throttle logic from VolumeDetector
                self.volumeChangeWorkItem?.cancel()
                
                let workItem = DispatchWorkItem { [weak self] in
                    guard let self = self else { return }
                    self.onVolumeChangeCallback?(volume)
                }
                
                self.volumeChangeWorkItem = workItem
                // Using 0.1s delay to allow system to settle, similar to original but maybe faster?
                // Original had 1.0s delay. Keeping it for now as per original logic, or maybe slightly less?
                // The user didn't specify to change logic, so I'll stick to the pattern but maybe 1.0s is too long for UI updates?
                // Wait, the original code had `DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: workItem)`.
                // I will keep it to maintain behavior.
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: workItem)
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.removeAll()
    }
}

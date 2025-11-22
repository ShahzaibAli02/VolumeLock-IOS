//
//  VolumeDetector.swift
//  VolumeLock
//
//  Created by Shahzaib Ali on 23/11/2025.
//

import AVFoundation
import Combine
import UIKit

class VolumeDetector {
    private var cancellables = Set<AnyCancellable>()
    private var volumeChangeWorkItem: DispatchWorkItem?
    // Current volume (0.0 – 1.0)
    var currentVolume: Float {
        AVAudioSession.sharedInstance().outputVolume
    }
    
    private var onVolumeChange : (Float) -> Void = {_ in }
    
    init() {
        startObservingVolumeChanges()
    }
    
    private func startObservingVolumeChanges() {
        let notificationName: NSNotification.Name
        
        if #available(iOS 15, *) {
            notificationName = NSNotification.Name(rawValue: "SystemVolumeDidChange")
        } else {
            notificationName = NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification")
        }
        
        // Modern Combine way
        NotificationCenter.default.publisher(for: notificationName)
            .sink { [weak self] notification in
                guard let self = self else { return }
                
                let volume = notification.userInfo?["AVSystemController_AudioVolumeNotificationParameter"] as? Float
                                    ?? notification.userInfo?["Volume"] as? Float  // Fallback for iOS 15+
                                    ?? self.currentVolume
                
                let reason = notification.userInfo?["AVSystemController_AudioVolumeChangeReasonNotificationParameter"] as? String
                
                print("Volume changed to: \(volume)")
                
                switch reason {
                case "ExplicitVolumeChange": print("→ User pressed hardware buttons or slider")
                case "SystemVolumeChange":   print("→ Changed by system (e.g. call, alarm)")
                default: break
                }
                
                
                
                // Cancel previous pending task
                        volumeChangeWorkItem?.cancel()
                        
                        // Create new task
                        let workItem = DispatchWorkItem { [weak self] in
                            guard let self = self else { return }
                            onVolumeChange(volume)
                            // This runs only if no new volume change happened in the last 1 second
//                            if self.isStarted {
//                                self.setSystemVolume(volume)
//                                print("Volume applied after user stopped: \(volume)")
//                            }
                        }
                        
                        // Save reference and schedule
                        self.volumeChangeWorkItem = workItem
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: workItem)
             
//                self.volumeDidChange(volume, reason: reason)
            }
            .store(in: &cancellables)
    }
    
    func onVolumeChange(_ onVolumeChange : @escaping (Float) -> Void) {
        self.onVolumeChange = onVolumeChange
        // Put your code here! (e.g., update UI, trigger haptic, etc.)
    }
    
    deinit {
        cancellables.removeAll()
    }
}

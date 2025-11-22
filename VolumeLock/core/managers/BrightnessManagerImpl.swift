//
//  BrightnessManagerImpl.swift
//  VolumeLock
//
//  Created by Shahzaib Ali on 23/11/2025.
//

import UIKit
import Combine

class BrightnessManagerImpl: BrightnessManager {
    private var cancellables = Set<AnyCancellable>()
    private var onBrightnessChangeCallback: ((Float) -> Void)?
    
    var currentBrightness: Float {
        Float(UIScreen.main.brightness)
    }
    
    init() {
        startObservingBrightnessChanges()
    }
    
    func setBrightness(_ level: Float) {
        print("CHANGE BRIGHTNESS TO \(level)")
        DispatchQueue.main.async{
            UIScreen.main.brightness = CGFloat(level)
        }
       
    }
    
    func onBrightnessChange(_ callback: @escaping (Float) -> Void) {
        self.onBrightnessChangeCallback = callback
    }
    
    private func startObservingBrightnessChanges() {
        NotificationCenter.default.publisher(for: UIScreen.brightnessDidChangeNotification)
            .sink { [weak self] _ in
                guard let self = self else { return }
                let brightness = self.currentBrightness
                print("BrightnessManagerImpl: Brightness changed to: \(brightness)")
                self.onBrightnessChangeCallback?(brightness)
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.removeAll()
    }
}

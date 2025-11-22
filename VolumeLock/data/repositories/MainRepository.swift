//
//  MainRepository.swift
//  VolumeLock
//
//  Created by Shahzaib Ali on 23/11/2025.
//

import Foundation

class MainRepository {
    private let soundManager: SoundManager
    private let brightnessManager: BrightnessManager
    
    init(soundManager: SoundManager, brightnessManager: BrightnessManager) {
        self.soundManager = soundManager
        self.brightnessManager = brightnessManager
    }
    
    func setVolume(_ level: Float) {
        soundManager.setSystemVolume(level)
    }
    
    func observeVolumeChanges(_ callback: @escaping (Float) -> Void) {
        soundManager.onVolumeChange(callback)
    }
    
    func setBrightness(_ level: Float) {
        brightnessManager.setBrightness(level)
    }
    
    func getBrightness() -> Float {
        brightnessManager.currentBrightness
    }
    
    func observeBrightnessChanges(_ callback: @escaping (Float) -> Void) {
        brightnessManager.onBrightnessChange(callback)
    }
}

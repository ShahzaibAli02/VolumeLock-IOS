//
//  BrightnessManager.swift
//  VolumeLock
//
//  Created by Shahzaib Ali on 23/11/2025.
//

import Foundation

protocol BrightnessManager {
    var currentBrightness: Float { get }
    func setBrightness(_ level: Float)
    func onBrightnessChange(_ callback: @escaping (Float) -> Void)
}

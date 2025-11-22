//
//  SoundManager.swift
//  VolumeLock
//
//  Created by Shahzaib Ali on 23/11/2025.
//

import Foundation

protocol SoundManager {
    func setSystemVolume(_ level: Float)
    func onVolumeChange(_ callback: @escaping (Float) -> Void)
}

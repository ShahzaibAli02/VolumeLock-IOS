//
//  MainViewModel.swift
//  VolumeLock
//
//  Created by Shahzaib Ali on 23/11/2025.
//

import Foundation
import Combine
import UIKit

enum LockDuration: String, CaseIterable, Identifiable {
    case oneHour = "1 Hour"
    case twoHours = "2 Hours"
    case threeHours = "3 Hours"
    case fourHours = "4 Hours"
    case fiveHours = "5 Hours"
    
    var id: String { self.rawValue }
    
    var timeInterval: TimeInterval {
        switch self {
        case .oneHour: return 3600
        case .twoHours: return 7200
        case .threeHours: return 10800
        case .fourHours: return 14400
        case .fiveHours: return 18000
        }
    }
}

class MainViewModel: ObservableObject {
    @Published var volume: Double = 0.5
    @Published var brightness: Double = 0.5
    @Published var isStarted: Bool = false
    @Published var lockDuration: LockDuration = .threeHours
    @Published var remainingTime: TimeInterval = 0
    
    private let repository: MainRepository
    private var timer: AnyCancellable?
    
    var formattedRemainingTime: String {
        let hours = Int(remainingTime) / 3600
        let minutes = Int(remainingTime) / 60 % 60
        let seconds = Int(remainingTime) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    init(repository: MainRepository) {
        self.repository = repository
        self.brightness = Double(repository.getBrightness())
        
        // Start observing volume changes
        repository.observeVolumeChanges { [weak self] newVolume in
            DispatchQueue.main.async {
                self?.handleVolumeChange(newVolume)
            }
        }
        
        // Start observing brightness changes
        repository.observeBrightnessChanges { [weak self] newBrightness in
            DispatchQueue.main.async {
                self?.handleBrightnessChange(newBrightness)
            }
        }
    }
    
    func increaseVolume() {
        volume = min(1.0, volume + 0.1)
        repository.setVolume(Float(volume))
    }
    
    func decreaseVolume() {
        volume = max(0.0, volume - 0.1)
        repository.setVolume(Float(volume))
    }
    
    func setVolume(_ value: Double) {
        volume = value
        repository.setVolume(Float(value))
    }
    
    private var window: UIWindow? = nil
    func setBrightness(_ value: Double) {
        brightness = value
        repository.setBrightness(Float(value))
    }
    
    
    
    func toggleStart() {
        isStarted.toggle()
        if isStarted {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    private func startTimer() {
        remainingTime = lockDuration.timeInterval
        print("Timer started for \(remainingTime) seconds")
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect().sink { [weak self] _ in
            guard let self = self else { return }
            self.remainingTime -= 1
            if self.remainingTime <= 0 {
                self.toggleStart()
            }
        }
    }
    
    private func stopTimer() {
        print("Timer stopped")
        timer?.cancel()
        timer = nil
    }
    
    private func handleVolumeChange(_ newVolume: Float) {
        if isStarted {
            if abs(Float(volume) - newVolume) > 0.001 {
                print("MainViewModel: Volume changed to \(newVolume) while locked. Reverting to \(volume)")
                repository.setVolume(Float(volume))
            }
        } else {
            self.volume = Double(newVolume)
        }
    }
    
    private func handleBrightnessChange(_ newBrightness: Float) {
        if isStarted {
            if abs(Float(brightness) - newBrightness) > 0.001 {
                print("MainViewModel: Brightness changed to \(newBrightness) while locked. Reverting to \(brightness)")
            repository.setBrightness(Float(brightness))
            }
        } else {
            self.brightness = Double(newBrightness)
        }
    }
}

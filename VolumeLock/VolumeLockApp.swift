//
//  VolumeLockApp.swift
//  VolumeLock
//
//  Created by Shahzaib Ali on 22/11/2025.
//

import SwiftUI

@main
struct VolumeLockApp: App {
    // Keep strong references to services if needed, but here ViewModel holds them.
    // We create them once here.
    private let soundManager = SoundManagerImpl()
    private let brightnessManager = BrightnessManagerImpl()
    private var repository: MainRepository
    
    init() {
        self.repository = MainRepository(soundManager: soundManager, brightnessManager: brightnessManager)
    }

    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MainViewModel(repository: repository))
        }
    }
}

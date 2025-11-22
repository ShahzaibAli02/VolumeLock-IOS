//
//  AppColors.swift
//  VolumeLock
//
//  Created by Shahzaib Ali on 23/11/2025.
//

import SwiftUI

struct AppColors {
    static let backgroundGradientStart = Color(hex: "1A2151")
    static let backgroundGradientEnd = Color(hex: "2A4E6C")
    
    static let startButtonGradientStart = Color.cyan
    static let startButtonGradientEnd = Color.blue
    
    static let startButtonFillStart = Color.blue.opacity(0.8)
    static let startButtonFillEnd = Color.cyan.opacity(0.8)
    
    static let startButtonActiveGradientStart = Color.green
    static let startButtonActiveGradientEnd = Color(hex: "00FF00") // Bright green
    
    static let startButtonActiveFillStart = Color.green.opacity(0.8)
    static let startButtonActiveFillEnd = Color(hex: "32CD32").opacity(0.8) // LimeGreen
    
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.8)
    static let accent = Color.cyan
    static let controlTint = Color.blue
}

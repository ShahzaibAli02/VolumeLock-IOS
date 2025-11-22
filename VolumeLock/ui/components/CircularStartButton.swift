//
//  CircularStartButton.swift
//  VolumeLock
//
//  Created by Shahzaib Ali on 23/11/2025.
//

import SwiftUI

struct CircularStartButton: View {
    let isStarted: Bool
    let timerText: String?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Outer glowing ring
                Circle()
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                isStarted ? AppColors.startButtonActiveGradientStart : AppColors.startButtonGradientStart,
                                isStarted ? AppColors.startButtonActiveGradientEnd : AppColors.startButtonGradientEnd
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 4
                    )
                    .frame(width: 180, height: 180)
                    .shadow(color: (isStarted ? Color.green : AppColors.accent).opacity(0.5), radius: 10, x: 0, y: 0)
                
                // Inner ring
                Circle()
                    .stroke(Color.white.opacity(0.2), lineWidth: 15)
                    .frame(width: 150, height: 150)
                
                // Fill
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                isStarted ? AppColors.startButtonActiveFillStart : AppColors.startButtonFillStart,
                                isStarted ? AppColors.startButtonActiveFillEnd : AppColors.startButtonFillEnd
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 140, height: 140)
                
                // Text
                VStack(spacing: 4) {
                    Text(isStarted ? "STOP" : "START")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(AppColors.textPrimary)
                    
                    if isStarted, let timerText = timerText {
                        Text(timerText)
                            .font(.system(size: 16, weight: .medium, design: .monospaced))
                            .foregroundColor(AppColors.textPrimary.opacity(0.9))
                    }
                }
            }
        }
    }
}

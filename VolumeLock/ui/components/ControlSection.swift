//
//  ControlSection.swift
//  VolumeLock
//
//  Created by Shahzaib Ali on 23/11/2025.
//

import SwiftUI

struct ControlSection<Content: View>: View {
    let title: String
    let icon: String
    let valueText: String
    let content: Content
    
    init(title: String, icon: String, valueText: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.valueText = valueText
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .foregroundColor(AppColors.textSecondary)
                    .font(.subheadline)
                Spacer()
                if !icon.isEmpty {
                    Image(systemName: icon)
                        .foregroundColor(AppColors.textSecondary)
                }
                if !valueText.isEmpty {
                    Text(valueText)
                        .foregroundColor(AppColors.textSecondary)
                        .font(.subheadline)
                }
            }
            
            // For Volume, the original design had the percentage below title, next to icon.
            // But for generic reuse, we might need flexibility.
            // Let's stick to the structure: Title ... (Icon + Value if applicable)
            // Wait, the original Volume control had: Title, then HStack(Icon, Value), then Slider.
            // Brightness had: HStack(Title, Spacer, Icon, Value), then Slider.
            // They are slightly different.
            // Let's make this component flexible or stick to one style?
            // The user asked for "clean code" and "reuse".
            // I will standardize to the Brightness style (Title ... Icon Value) as it's cleaner?
            // Or I can support the Volume style via the `content` block if I only provide the container.
            // Actually, let's just put the content below.
            
            content
        }
    }
}

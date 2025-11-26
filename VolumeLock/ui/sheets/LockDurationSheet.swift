import SwiftUI

struct LockDurationSheet: View {
    let isPremiumUser : Bool
    @ObservedObject var viewModel: MainViewModel
    @Environment(\.presentationMode) var presentationMode
    var onBuyPremium : () -> Void
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [AppColors.backgroundGradientStart, AppColors.backgroundGradientEnd]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                // Header
                HStack {
                    Spacer()
                    Text("Lock Duration")
                        .font(.headline)
                        .foregroundColor(AppColors.textPrimary)
                    Spacer()
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.accent)
                }
                .padding()
                
                // List
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(Array(LockDuration.allCases.enumerated()), id: \.element) { index, duration in
                            let isLocked = index >= 2 && !isPremiumUser
                            let isSelected = viewModel.lockDuration == duration
                            
                            Button(action: {
                                if !isLocked {
                                    viewModel.lockDuration = duration
                                }
                                else {
                                    onBuyPremium()
                                }
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(duration.rawValue)
                                            .font(.body)
                                            .foregroundColor(isLocked ? AppColors.textSecondary.opacity(0.5) : AppColors.textPrimary)
                                        
                                        if isLocked {
                                            HStack(spacing: 4) {
                                                Text("Pro Feature")
                                                    .font(.caption)
                                                    .foregroundColor(AppColors.accent)
                                                Image(systemName: "crown.fill")
                                                    .font(.caption)
                                                    .foregroundColor(AppColors.accent)
                                            }
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    if isSelected {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(AppColors.accent)
                                    } else if isLocked {
                                        Image(systemName: "lock.fill")
                                            .foregroundColor(AppColors.textSecondary.opacity(0.5))
                                    }
                                }
                                .padding()
                                .background(Color.white.opacity(0.05))
                            }
                            
                            if index < LockDuration.allCases.count - 1 {
                                Divider()
                                    .background(Color.white.opacity(0.1))
                            }
                        }
                    }
                    .cornerRadius(12)
                    .padding()
                }
                
                Spacer()
                
                // Upgrade Button
                if !isPremiumUser {
                    Button(action: {
                        onBuyPremium()
                        // Action to upgrade
                        print("Upgrade tapped")
                        // viewModel.isPremiumUser = true // Uncomment to test
                    }) {
                        HStack {
                            Image(systemName: "crown.fill")
                            Text("Upgrade to Pro")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [AppColors.startButtonGradientStart, AppColors.startButtonGradientEnd]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                    }
                    .padding()
                }
            }
        }
    }
}

struct LockDurationSheet_Previews: PreviewProvider {
    static var previews: some View {
        let soundManager = SoundManagerImpl()
        let brightnessManager = BrightnessManagerImpl()
        let repository = MainRepository(soundManager: soundManager, brightnessManager: brightnessManager)
        let viewModel = MainViewModel(repository: repository)
        LockDurationSheet(
            isPremiumUser: false,
            viewModel: viewModel,
            onBuyPremium: {
            })
    }
}

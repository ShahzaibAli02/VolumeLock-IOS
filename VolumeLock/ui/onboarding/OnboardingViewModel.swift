import Foundation
import SwiftUI
import Combine
import UIKit
struct OnboardingSlide: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let text: String
}

class OnboardingViewModel: ObservableObject {
    @Published var currentPage: Int = 0
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false

    let slides: [OnboardingSlide] = [
        OnboardingSlide(
            image: "onboarding_1",
            title: "Protect Your Child’s Hearing",
            text: "● Lock the volume so your kids can’t play their phone too loud.\n\n● Works across all apps, videos, games, and music.\n\n● Keep a safe and consistent volume level effortlessly."
        ),
        OnboardingSlide(
            image: "onboarding_2",
            title: "Set Your Safe Volume",
            text: "● Use the slider to select the maximum volume.\n\n● Pick how long you want the volume locked.\n\n● Your settings stay active while the app is in the background. Do not close the app."
        ),
        OnboardingSlide(
            image: "onboarding_3",
            title: "Simple. Safe. Smart.",
            text: "\n● Protect your child’s ears from loud sounds.\n\n● Easy to adjust whenever needed. Peace of mind for parents, fun for kids."
        )
    ]
    
    func nextPage() {
        if currentPage < slides.count - 1 {
            currentPage += 1
        }
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
    }
}

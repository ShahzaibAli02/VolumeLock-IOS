import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            
            VStack {
                TabView(selection: $viewModel.currentPage) {
                    ForEach(0..<viewModel.slides.count, id: \.self) { index in
                        OnboardingSlideView(slide: viewModel.slides[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: viewModel.currentPage)
                
                // Page Indicator
                HStack(spacing: 8) {
                    ForEach(0..<viewModel.slides.count, id: \.self) { index in
                        Circle()
                            .fill(index == viewModel.currentPage ? Color.blue : Color.gray.opacity(0.5))
                            .frame(width: 8, height: 8)
                            .scaleEffect(index == viewModel.currentPage ? 1.2 : 1.0)
                            .animation(.spring(), value: viewModel.currentPage)
                    }
                }
                .padding(.bottom, 20)
                
                // Navigation Button
                Button(action: {
                    if viewModel.currentPage < viewModel.slides.count - 1 {
                        withAnimation {
                            viewModel.nextPage()
                        }
                    } else {
                        viewModel.completeOnboarding()
                    }
                }) {
                    Text(viewModel.currentPage == viewModel.slides.count - 1 ? "Get Started" : "Next")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                        .padding(.horizontal, 24)
                }
                .padding(.bottom, 40)
            }
        }
    }
}

struct OnboardingSlideView: View {
    let slide: OnboardingSlide
    
    var body: some View {
        ScrollView(.vertical) {
        VStack(spacing: 20) {
            Spacer()
            
            Image(slide.image)
                .resizable()
                .scaledToFit()
                .frame(height: 300.sp) // 30% of screen height
                .cornerRadius(20) // Rounded corners
                .padding(.horizontal)
            
            Text(slide.title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
                .padding(.horizontal, 10)
            
            Text(slide.text)
                .font(.body)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.leading)
                .foregroundColor(.secondary)
                .padding(.horizontal, 30)
            
            Spacer()
        }
        }
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

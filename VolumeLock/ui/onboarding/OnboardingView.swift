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
                .font(.system(size: 28.sp, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.top, 20)
                .padding(.horizontal, 10)
                .padding(.top,20.sp)
            
            let lines = slide.text.split(separator: "\n").map(String.init)

            VStack(alignment: .leading, spacing: 20) {
                ForEach(lines, id: \.self) { line in
                    HStack(alignment: .top, spacing: 10) {
                        Circle()
                            .fill(Color.secondary)
                            .frame(width: 15.sp, height: 15.sp)
                            .padding(.top, 6) // align dot with text

                        Text(line)
                            .font(.system(size: 21.sp))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
            .padding(.horizontal, 30)
            .padding(.top, 20.sp)
            
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

import SwiftUI

struct OnboardingScreen: View {

    var onGetStarted: () -> Void = {}

    @State private var currentIndex = 0
    @State private var imageVisible = false
    @State private var textVisible  = false

    private let screen = UIScreen.main.bounds

    var body: some View {
        ZStack {
            Color(hex: "#2B7FD4").ignoresSafeArea()

            if OnboardingData.pages[currentIndex].imageOnTop {
                OnboardingLayoutTop(
                    page: OnboardingData.pages[currentIndex],
                    imageVisible: imageVisible,
                    textVisible: textVisible,
                    currentIndex: currentIndex,
                    totalPages: OnboardingData.pages.count,
                    onNext: handleNext
                )
            } else {
                OnboardingLayoutBottom(
                    page: OnboardingData.pages[currentIndex],
                    imageVisible: imageVisible,
                    textVisible: textVisible,
                    currentIndex: currentIndex,
                    totalPages: OnboardingData.pages.count,
                    onNext: handleNext
                )
            }
        }
        .onAppear { triggerAnimations() }
    }

    // MARK: - Actions
    private func handleNext() {
        guard currentIndex < OnboardingData.pages.count - 1 else { onGetStarted(); return }
        withAnimation { imageVisible = false; textVisible = false }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            currentIndex += 1
            triggerAnimations()
        }
    }

    private func triggerAnimations() {
        imageVisible = false
        textVisible  = false
        withAnimation { imageVisible = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation { textVisible = true }
        }
    }
}

#Preview {
    OnboardingScreen()
}

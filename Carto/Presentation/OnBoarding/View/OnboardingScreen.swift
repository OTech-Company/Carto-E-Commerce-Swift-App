import SwiftUI

struct OnboardingScreen: View {

    var onGetStarted: () -> Void = {}

    @State private var currentIndex  = 0
    @State private var imageVisible  = false
    @State private var textVisible   = false
    @State private var showBags      = false   // ← new

    private let screen = UIScreen.main.bounds

    var body: some View {
        ZStack {
            Color(hex: "#2B7FD4").ignoresSafeArea()

            if showBags {
                // MARK: - Bags transition screen
                BagsTransitionView(onFinished: onGetStarted)
            } else {
                // MARK: - Normal onboarding pages
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
        }
        .onAppear { triggerAnimations() }
    }

    // MARK: - Actions
    private func handleNext() {
        guard currentIndex < OnboardingData.pages.count - 1 else {
            // Last page — show bags transition instead of going directly
            withAnimation(.easeInOut(duration: 0.3)) { showBags = true }
            return
        }
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

    OnboardingScreen( )

}

import SwiftUI

struct OnboardingPage {
    let outlinedText: [String]
    let boldText: String
    let imageName: String
    let imageRotation: Double
    let imageOnTop: Bool
}

struct OnboardingScreen: View {

    var onGetStarted: () -> Void = {}

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            outlinedText: ["DISCOVER", "THOUSANDS OF"],
            boldText: "PRODUCTS.",
            imageName: "onboarding_browse",
            imageRotation: 0,
            imageOnTop: false   // text top, image slides in from RIGHT
        ),
        OnboardingPage(
            outlinedText: ["ADD TO CART", "WITH"],
            boldText: "ONE TAP.",
            imageName: "onboarding_cart",
            imageRotation: 0,
            imageOnTop: true    // image slides in from TOP, text bottom
        ),
        OnboardingPage(
            outlinedText: ["FAST &", "SECURE"],
            boldText: "CHECKOUT.",
            imageName: "onboarding_pay",
            imageRotation: 0,
            imageOnTop: false   // text top, image slides in from RIGHT
        )
    ]

    @State private var currentIndex  = 0
    @State private var imageVisible  = false
    @State private var textVisible   = false

    private let screen = UIScreen.main.bounds

    var body: some View {
        ZStack {
            Color(hex: "#2B7FD4").ignoresSafeArea()

            if pages[currentIndex].imageOnTop {
                layoutImageTop
            } else {
                layoutTextTop
            }
        }
        .onAppear { triggerAnimations() }
    }

    // MARK: - Layout A: Image TOP (bag page — drops from top)
    private var layoutImageTop: some View {
        VStack(spacing: 0) {

            // Image — enters from top
            Image(pages[currentIndex].imageName)
                .resizable()
                .scaledToFit()
                .frame(width: screen.width, height: screen.height * 0.50)
                .clipped()
                .offset(y: imageVisible ? 0 : -screen.height * 0.55)
                .opacity(imageVisible ? 1 : 0)
                .animation(.spring(response: 0.65, dampingFraction: 0.78), value: imageVisible)

            // Text + controls — bottom half
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                headlineBlock
                Spacer()
                controlsRow
                Spacer().frame(height: 36)
            }
            .padding(.horizontal, 28)
            .frame(width: screen.width, height: screen.height * 0.50)
        }
    }

    // MARK: - Layout B: Text TOP (browse + pay — image slides from right)
    private var layoutTextTop: some View {
        VStack(spacing: 0) {

            // Text + controls — top half
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                headlineBlock
                Spacer()
                controlsRow
                Spacer().frame(height: 20)
            }
            .padding(.horizontal, 28)
            .frame(width: screen.width, height: screen.height * 0.44)

            // Image — enters from right
            Image(pages[currentIndex].imageName)
                .resizable()
                .scaledToFit()
                .frame(width: screen.width, height: screen.height * 0.56)
                .clipped()
                .offset(x: imageVisible ? 0 : screen.width)
                .opacity(imageVisible ? 1 : 0)
                .animation(.spring(response: 0.65, dampingFraction: 0.78), value: imageVisible)
        }
    }

    // MARK: - Headline Block
    private var headlineBlock: some View {
        VStack(alignment: .leading, spacing: 2) {
            ForEach(pages[currentIndex].outlinedText, id: \.self) { line in
                outlinedHeadline(line)
            }
            Text(pages[currentIndex].boldText)
                .font(.system(size: 44, weight: .black))
                .foregroundStyle(.white)
                .padding(.top, 6)
        }
        .offset(y: textVisible ? 0 : 24)
        .opacity(textVisible ? 1 : 0)
        .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.2), value: textVisible)
    }

    // MARK: - Dots + Button Row
    private var controlsRow: some View {
        HStack {
            // Dots
            HStack(spacing: 8) {
                ForEach(0..<pages.count, id: \.self) { i in
                    Capsule()
                        .fill(.white.opacity(i == currentIndex ? 1 : 0.35))
                        .frame(width: i == currentIndex ? 24 : 8, height: 8)
                        .animation(.spring(response: 0.4), value: currentIndex)
                }
            }

            Spacer()

            // Button
            Button(action: handleNext) {
                Text(currentIndex == pages.count - 1 ? "Get Started" : "Next")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.black)
                    .frame(
                        width: currentIndex == pages.count - 1 ? 160 : 110,
                        height: 54
                    )
                    .background(.white)
                    .clipShape(Capsule())
                    .animation(.spring(response: 0.4), value: currentIndex)
            }
        }
        .offset(y: textVisible ? 0 : 24)
        .opacity(textVisible ? 1 : 0)
        .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.35), value: textVisible)
    }

    // MARK: - Actions
    private func handleNext() {
        guard currentIndex < pages.count - 1 else { onGetStarted(); return }
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

    // MARK: - Outlined Headline
    @ViewBuilder
    private func outlinedHeadline(_ text: String) -> some View {
        ZStack {
            Text(text).font(.system(size: 44, weight: .black)).foregroundStyle(.white.opacity(0.35)).offset(x: -1.5, y: -1.5)
            Text(text).font(.system(size: 44, weight: .black)).foregroundStyle(.white.opacity(0.35)).offset(x:  1.5, y: -1.5)
            Text(text).font(.system(size: 44, weight: .black)).foregroundStyle(.white.opacity(0.35)).offset(x: -1.5, y:  1.5)
            Text(text).font(.system(size: 44, weight: .black)).foregroundStyle(.white.opacity(0.35)).offset(x:  1.5, y:  1.5)
            Text(text).font(.system(size: 44, weight: .black)).foregroundStyle(Color(hex: "#2B7FD4"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Hex Color
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double(int & 0xFF)          / 255
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    OnboardingScreen()
}

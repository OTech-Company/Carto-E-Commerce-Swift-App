import SwiftUI

// MARK: - Onboarding Data Model
struct OnboardingPage {
    let outlinedText: [String]
    let boldText: String
    let imageName: String
    let imageRotation: Double
    let imageOnTop: Bool        // true = image top / false = text top
}

struct OnboardingScreen: View {

    var onGetStarted: () -> Void = {}

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            outlinedText: ["DISCOVER", "THOUSANDS OF"],
            boldText: "PRODUCTS.",
            imageName: "onboarding_shopping",
            imageRotation: -5,
            imageOnTop: false        // text top, image bottom
        ),
        OnboardingPage(
            outlinedText: ["ADD TO CART", "WITH"],
            boldText: "ONE TAP.",
            imageName: "onboarding_bag",
            imageRotation: 0,
            imageOnTop: true         // image top, text bottom
        ),
        OnboardingPage(
            outlinedText: ["FAST &", "SECURE"],
            boldText: "CHECKOUT.",
            imageName: "onboarding_cash1",
            imageRotation: -3,
            imageOnTop: false        // text top, image bottom
        )
    ]

    @State private var currentIndex = 0
    @State private var imageVisible = false
    @State private var textVisible  = false

    private let screenHeight = UIScreen.main.bounds.height
    private let screenWidth  = UIScreen.main.bounds.width

    var body: some View {
        ZStack {
            Color(hex: "#2B7FD4").ignoresSafeArea()

            if pages[currentIndex].imageOnTop {
                // MARK: - Layout A: Image Top / Text Bottom (bag page)
                VStack(spacing: 0) {
                    imageView
                        .frame(height: screenHeight * 0.52)

                    textBlock
                        .padding(.horizontal, 28)
                        .frame(height: screenHeight * 0.48)
                }

            } else {
                // MARK: - Layout B: Text Top / Image Bottom (browse + pay pages)
                VStack(spacing: 0) {
                    textBlock
                        .padding(.horizontal, 28)
                        .frame(height: screenHeight * 0.44)

                    imageView
                        .frame(height: screenHeight * 0.56)
                }
            }
        }
        .onAppear { triggerAnimations() }
    }

    // MARK: - Image View
    private var imageView: some View {
        Image(pages[currentIndex].imageName)
            .resizable()
            .scaledToFit()
            .rotationEffect(.degrees(pages[currentIndex].imageRotation))
            .padding(.horizontal, 16)
            // Image enters from top if imageOnTop, from bottom if not
            .offset(y: imageVisible
                ? 0
                : pages[currentIndex].imageOnTop
                    ? -screenHeight * 0.6
                    :  screenHeight * 0.6
            )
            .opacity(imageVisible ? 1 : 0)
            .animation(.spring(response: 0.65, dampingFraction: 0.78), value: imageVisible)
    }

    // MARK: - Text Block
    private var textBlock: some View {
        VStack(alignment: .leading, spacing: 0) {

            Spacer()

            VStack(alignment: .leading, spacing: 2) {
                ForEach(pages[currentIndex].outlinedText, id: \.self) { line in
                    outlinedHeadline(line)
                }
                Text(pages[currentIndex].boldText)
                    .font(.system(size: 42, weight: .black))
                    .foregroundStyle(.white)
                    .padding(.top, 4)
            }
            .offset(y: textVisible ? 0 : 30)
            .opacity(textVisible ? 1 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.2), value: textVisible)

            Spacer()

            // MARK: - Dots + Button
            HStack {
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Capsule()
                            .fill(.white.opacity(index == currentIndex ? 1 : 0.35))
                            .frame(width: index == currentIndex ? 24 : 8, height: 8)
                            .animation(.spring(response: 0.4), value: currentIndex)
                    }
                }

                Spacer()

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
            .offset(y: textVisible ? 0 : 30)
            .opacity(textVisible ? 1 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.35), value: textVisible)

            Spacer()
                .frame(height: 20)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Actions
    private func handleNext() {
        guard currentIndex < pages.count - 1 else {
            onGetStarted()
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

    // MARK: - Outlined Headline
    @ViewBuilder
    private func outlinedHeadline(_ text: String) -> some View {
        ZStack {
            Text(text).font(.system(size: 42, weight: .black)).foregroundStyle(.white.opacity(0.35)).offset(x: -1.5, y: -1.5)
            Text(text).font(.system(size: 42, weight: .black)).foregroundStyle(.white.opacity(0.35)).offset(x:  1.5, y: -1.5)
            Text(text).font(.system(size: 42, weight: .black)).foregroundStyle(.white.opacity(0.35)).offset(x: -1.5, y:  1.5)
            Text(text).font(.system(size: 42, weight: .black)).foregroundStyle(.white.opacity(0.35)).offset(x:  1.5, y:  1.5)
            Text(text).font(.system(size: 42, weight: .black)).foregroundStyle(Color(hex: "#2B7FD4"))
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

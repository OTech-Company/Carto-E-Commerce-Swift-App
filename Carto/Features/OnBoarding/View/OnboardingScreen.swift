import SwiftUI

struct OnboardingScreen: View {

    var onGetStarted: () -> Void = {}

    var body: some View {
        ZStack(alignment: .bottomLeading) {

            // MARK: - Background
            Color(hex: "#2B7FD4")
                .ignoresSafeArea()

            // MARK: - Shoe Image (bottom layer)
            Image("onboarding_shoe")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width )


            // MARK: - Content (top layer)
            VStack(alignment: .leading, spacing: 0) {

                Spacer()

                // MARK: - Outlined text
                outlinedHeadline("YOU HAVE THE")
                outlinedHeadline("POWER TO")

                // MARK: - Bold text
                Text("JUST BUY IT.")
                    .font(.system(size: 46, weight: .black))
                    .foregroundStyle(.white)
                    .padding(.top, 6)

                Spacer()
                    .frame(height: 32)

                // MARK: - Button
                Button(action: onGetStarted) {
                    Text("Get Started")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.black)
                        .frame(width: 180, height: 54)
                        .background(.white)
                        .clipShape(Capsule())
                }

                Spacer()
                Spacer()
                Spacer()
            }
            .padding(.horizontal, 28)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    // MARK: - Outlined text helper
    @ViewBuilder
    private func outlinedHeadline(_ text: String) -> some View {
        ZStack {
            // Stroke layer — shift in all 4 directions
            Text(text)
                .font(.system(size: 46, weight: .black))
                .foregroundStyle(.white.opacity(0.35))
                .offset(x: -1.5, y: -1.5)
            Text(text)
                .font(.system(size: 46, weight: .black))
                .foregroundStyle(.white.opacity(0.35))
                .offset(x: 1.5, y: -1.5)
            Text(text)
                .font(.system(size: 46, weight: .black))
                .foregroundStyle(.white.opacity(0.35))
                .offset(x: -1.5, y: 1.5)
            Text(text)
                .font(.system(size: 46, weight: .black))
                .foregroundStyle(.white.opacity(0.35))
                .offset(x: 1.5, y: 1.5)

            // Fill layer — transparent center to show outline only
            Text(text)
                .font(.system(size: 46, weight: .black))
                .foregroundStyle(Color(hex: "#2B7FD4"))
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

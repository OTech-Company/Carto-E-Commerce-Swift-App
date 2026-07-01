import SwiftUI

struct ForgotPasswordSuccessView: View {
    @StateObject private var viewModel: ForgotPasswordSuccessViewModel

    init(viewModel: ForgotPasswordSuccessViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color(hex: "FAFAFA")
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "envelope.badge")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 72, height: 72)
                    .foregroundColor(Color(hex: "FF5A00"))

                VStack(spacing: 12) {
                    Text("Check Your Email")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.black)

                    Text("We sent a password reset link to your email address. Follow the instructions in the email to reset your password.")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 24)
                }

                Button(action: { viewModel.backToSignIn() }) {
                    Text("Back to Sign In")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color(hex: "FF5A00"))
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

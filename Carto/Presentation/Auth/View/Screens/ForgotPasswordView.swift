import SwiftUI

struct ForgotPasswordView: View {
    @StateObject private var viewModel: ForgotPasswordViewModel

    init(viewModel: ForgotPasswordViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color(hex: "FAFAFA")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "FF5A00").opacity(0.08))
                                .frame(width: 140, height: 140)

                            Image(systemName: "lock.rotation")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 64, height: 64)
                                .foregroundColor(Color(hex: "FF5A00"))
                        }
                        .padding(.top, 40)

                        VStack(spacing: 12) {
                            Text("Forgot Password")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)

                            Text("Enter the email address associated with your account and we'll send you a secure password reset link.")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                                .padding(.horizontal, 16)
                        }

                        VStack(spacing: 24) {
                            AuthTextField(
                                label: "Email",
                                placeholder: "Enter your Email",
                                text: $viewModel.email,
                                error: viewModel.emailErrorMessage
                            ) {
                                viewModel.validateEmail()
                            }
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .disabled(viewModel.isLoading)

                            Button(action: { viewModel.sendResetLink() }) {
                                Text("Send Reset Link")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 52)
                                    .background(Color(hex: "FF5A00"))
                                    .cornerRadius(12)
                            }
                            .disabled(viewModel.isLoading)

                            if let generalErrorMessage = viewModel.generalErrorMessage {
                                Text(generalErrorMessage)
                                    .font(.system(size: 13))
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 16)
                                    .transition(.opacity)
                            }
                        }
                        .padding(.top, 12)
                    }
                    .padding(.horizontal, 24)
                }

                Spacer()

                HStack(spacing: 4) {
                    Text("Remember your password?")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)

                    Button(action: { viewModel.navigateToSignIn() }) {
                        Text("Back to Sign In")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(hex: "FF5A00"))
                            .frame(minWidth: 44, minHeight: 44)
                    }
                }
                .padding(.bottom, 24)
            }
            .blur(radius: viewModel.isLoading ? 2.0 : 0)
            .animation(.easeInOut, value: viewModel.generalErrorMessage)

            if viewModel.isLoading {
                Color.black.opacity(0.15)
                    .ignoresSafeArea()

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "FF5A00")))
                    .scaleEffect(1.5)
                    .frame(width: 80, height: 80)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 10)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

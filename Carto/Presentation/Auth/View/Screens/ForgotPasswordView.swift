import SwiftUI

struct ForgotPasswordView: View {
    @StateObject private var viewModel: ForgotPasswordViewModel
    @Environment(\.colorScheme) var colorScheme

    init(viewModel: ForgotPasswordViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        ZStack {
                            Circle()
                                .fill(Color("PrimaryColor").opacity(0.08))
                                .frame(width: 140, height: 140)

                            Image(systemName: "lock.rotation")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 64, height: 64)
                                .foregroundColor(Color("PrimaryColor"))
                        }
                        .padding(.top, 40)

                        VStack(spacing: 12) {
                            Text("forgot_password_title")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)

                            Text("forgot_password_desc")
                                .font(.system(size: 15))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                                .padding(.horizontal, 16)
                        }

                        VStack(spacing: 24) {
                            AuthTextField(
                                label: "email",
                                placeholder: "enter_your_email",
                                text: $viewModel.email,
                                error: viewModel.emailErrorMessage
                            ) {
                                viewModel.validateEmail()
                            }
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .disabled(viewModel.isLoading)

                            Button(action: { viewModel.sendResetLink() }) {
                                Text("send_reset_link_btn")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(.systemBackground))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 52)
                                    .background(Color("PrimaryColor"))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
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
                    Text("remember_password_link")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)

                    Button(action: { viewModel.navigateToSignIn() }) {
                        Text("back_to_signin_btn")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color("PrimaryColor"))
                            .frame(minWidth: 44, minHeight: 44)
                    }
                }
                .padding(.bottom, 24)
            }
            .blur(radius: viewModel.isLoading ? 2.0 : 0)
            .animation(.easeInOut, value: viewModel.generalErrorMessage)

            if viewModel.isLoading {
                Color.black.opacity(colorScheme == .dark ? 0.4 : 0.15)
                    .ignoresSafeArea()

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color("PrimaryColor")))
                    .scaleEffect(1.5)
                    .frame(width: 80, height: 80)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.1), radius: 10)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

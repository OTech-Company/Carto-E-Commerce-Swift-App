//
//  VerificationView.swift
//  Carto
//
//  Created by Mohamed Ayman on 30/06/2026.
//

import SwiftUI

struct VerificationView: View {
    @StateObject var viewModel: VerificationViewModel
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {

                        if let warningMessage = viewModel.warningMessage {
                            HStack(spacing: 12) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(Color("PrimaryColor")) // Corporate branding orange asset
                                    .font(.system(size: 16, weight: .semibold))

                                Text(warningMessage)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(Color("PrimaryColor").opacity(colorScheme == .dark ? 0.18 : 0.1)) // Enhanced dark mode visibility
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .accessibilityElement(children: .combine)
                        }

                        ZStack {
                            Circle()
                                .fill(Color("PrimaryColor").opacity(colorScheme == .dark ? 0.12 : 0.08)) // Smooth background glow
                                .frame(width: 140, height: 140)

                            Image(systemName: "envelope.badge.shield.half.filled")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .foregroundColor(Color("PrimaryColor")) // Corporate branding orange asset
                        }
                        .padding(.top, 40)

                        VStack(spacing: 12) {
                            Text("verify_email_title")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)

                            VStack(spacing: 6) {
                                Text("verification_sent_desc")
                                    .font(.system(size: 15))
                                    .foregroundColor(.secondary) // Updated from static .gray to adaptive semantic color

                                Text(viewModel.userEmail)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                            }
                            .multilineTextAlignment(.center)

                            Text("verification_desc")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary) // Updated from static .gray to adaptive semantic color
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                                .padding(.horizontal, 12)
                                .padding(.top, 8)
                        }

                        VStack(spacing: 16) {
                            Button(action: { viewModel.checkVerificationStatus() }) {
                                Text("continue_btn")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(.systemBackground)) // High contrast button label token
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 54)
                                    .background(Color("PrimaryColor")) // Corporate branding orange asset
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .accessibilityLabel("continue_check_verification")

                            Button(action: { viewModel.resendVerificationEmail() }) {
                                Text(viewModel.isResendDisabled ? "resend_in \(viewModel.countdownValue)s" : "resend_verification_email")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(viewModel.isResendDisabled ? Color(.placeholderText) : Color("PrimaryColor"))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                            }
                            .disabled(viewModel.isResendDisabled)
                        }
                        .padding(.top, 12)
                    }
                    .padding(.horizontal, 24)
                }

                Spacer()

                HStack(spacing: 4) {
                    Text("wrong_email_link")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary) // Updated from static .gray

                    Button(action: { viewModel.goBack() }) {
                        Text("go_back_btn")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color("PrimaryColor")) // Corporate branding orange asset
                            .frame(minWidth: 44, minHeight: 44)
                    }
                }
                .padding(.bottom, 24)
            }
            .blur(radius: viewModel.isLoading ? 2.0 : 0)
            .animation(.easeInOut, value: viewModel.warningMessage)

            if viewModel.isLoading {
                Color.black.opacity(colorScheme == .dark ? 0.4 : 0.12)
                    .ignoresSafeArea()

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color("PrimaryColor")))
                    .scaleEffect(1.4)
                    .frame(width: 80, height: 80)
                    .background(Color(.secondarySystemGroupedBackground)) // Clean panel container color across themes
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(colorScheme == .dark ? 0.3 : 0.08), radius: 10)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

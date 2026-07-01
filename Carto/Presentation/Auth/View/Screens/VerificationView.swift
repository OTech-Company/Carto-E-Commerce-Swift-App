//
//  VerificationView.swift
//  Carto
//
//  Created by Mohamed Ayman on 30/06/2026.
//

import SwiftUI

struct VerificationView: View {
    @StateObject var viewModel: VerificationViewModel

    var body: some View {
        ZStack {
            Color(hex: "FAFAFA")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {

                        if let warningMessage = viewModel.warningMessage {
                            HStack(spacing: 12) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(Color(hex: "FF5A00"))
                                    .font(.system(size: 16, weight: .semibold))

                                Text(warningMessage)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(Color(hex: "FF5A00").opacity(0.1))
                            .cornerRadius(12)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .accessibilityElement(children: .combine)
                        }

                        ZStack {
                            Circle()
                                .fill(Color(hex: "FF5A00").opacity(0.08))
                                .frame(width: 140, height: 140)

                            Image(systemName: "envelope.badge.shield.half.filled")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .foregroundColor(Color(hex: "FF5A00"))
                        }
                        .padding(.top, 40)

                        VStack(spacing: 12) {
                            Text("Verify Your Email")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)

                            VStack(spacing: 6) {
                                Text("We've sent a verification link to")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)

                                Text(viewModel.userEmail)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                            }
                            .multilineTextAlignment(.center)

                            Text("Please open your inbox and click the verification link. After verifying your email, return to the app and tap Continue.")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                                .padding(.horizontal, 12)
                                .padding(.top, 8)
                        }

                        VStack(spacing: 16) {
                            Button(action: { viewModel.checkVerificationStatus() }) {
                                Text("Continue")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 54)
                                    .background(Color(hex: "FF5A00"))
                                    .cornerRadius(12)
                            }
                            .accessibilityLabel("Continue check verification")

                            Button(action: { viewModel.resendVerificationEmail() }) {
                                Text(viewModel.isResendDisabled ? "Resend in \(viewModel.countdownValue)s" : "Resend Verification Email")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(viewModel.isResendDisabled ? .gray : Color(hex: "FF5A00"))
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
                    Text("Wrong email?")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)

                    Button(action: { viewModel.goBack() }) {
                        Text("Go Back")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(hex: "FF5A00"))
                            .frame(minWidth: 44, minHeight: 44)
                    }
                }
                .padding(.bottom, 24)
            }
            .blur(radius: viewModel.isLoading ? 2.0 : 0)
            .animation(.easeInOut, value: viewModel.warningMessage)

            if viewModel.isLoading {
                Color.black.opacity(0.12)
                    .ignoresSafeArea()

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "FF5A00")))
                    .scaleEffect(1.4)
                    .frame(width: 80, height: 80)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.08), radius: 10)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

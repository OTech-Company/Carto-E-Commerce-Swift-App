//
//  PaymentDemoView.swift
//  Carto
//
//  Created by Mohamed Ayman on 05/07/2026.
//
//

import SwiftUI

struct PaymentDemoView: View {
    @StateObject private var viewModel = PaymentDemoViewModel()

    var body: some View {
        VStack(spacing: 24) {
            Text("Payment Feature Demo")
                .font(.system(size: 18, weight: .bold))

            content

            if case .failed = viewModel.state {
                retryButton
            } else if case .idle = viewModel.state {
                retryButton
            }
        }
        .padding(24)
        .fullScreenCover(isPresented: isPresentingPayment) {
            if case .ready(let cart) = viewModel.state {
                PaymentView(cart: cart)
            }
        }
    }

    // MARK: - Content by State

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            Text("Creates a real cart from your live store, then opens Payment with a working checkout link.")
                .font(.system(size: 13))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

        case .loading:
            VStack(spacing: 12) {
                ProgressView()
                    .tint(.brandAccent)
                Text("Fetching a product and creating a cart…")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }

        case .failed(let message):
            Text(message)
                .font(.system(size: 13))
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

        case .ready:
            EmptyView() // fullScreenCover takes over immediately
        }
    }

    private var retryButton: some View {
        Button(viewModel.state == .idle ? "Create Real Cart & Preview Payment" : "Try Again") {
            Task { await viewModel.createRealCart() }
        }
        .font(.system(size: 16, weight: .semibold))
        .foregroundColor(.white)
        .padding(.horizontal, 28)
        .padding(.vertical, 14)
        .background(Color.brandAccent)
        .cornerRadius(14)
        .buttonStyle(PremiumScaleButtonStyle())
    }

    // MARK: - Presentation Binding

    private var isPresentingPayment: Binding<Bool> {
        Binding(
            get: {
                if case .ready = viewModel.state { return true }
                return false
            },
            set: { isPresented in
                if !isPresented { viewModel.reset() }
            }
        )
    }
}

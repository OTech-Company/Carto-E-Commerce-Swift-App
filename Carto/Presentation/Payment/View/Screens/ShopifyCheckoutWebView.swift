//
//  ShopifyCheckoutWebView.swift
//  Carto
//
//  Created by Mohamed Ayman on 05/07/2026.
//
//  Presents Shopify's hosted checkout (the cart's `checkoutUrl`) using
//  SFSafariViewController — NOT Checkout Sheet Kit, NOT ASWebAuthenticationSession.
//
//  Completion detection: Shopify's Order Status page redirects to a custom
//  URL scheme (e.g. `carto://checkout-complete`) once payment succeeds. iOS
//  intercepts that navigation, dismisses Safari automatically, and delivers
//  the URL to the app via `.onOpenURL`. If the customer manually taps "Done"
//  without completing payment, `safariViewControllerDidFinish` fires instead
//  — that's treated as a cancellation, not a success.
//

import SwiftUI
import SafariServices

// MARK: - SFSafariViewController Wrapper

struct ShopifyCheckoutWebView: UIViewControllerRepresentable {

    let url: URL

    let onManualDismiss: () -> Void

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let configuration = SFSafariViewController.Configuration()
        configuration.barCollapsingEnabled = true

        let controller = SFSafariViewController(url: url, configuration: configuration)
        controller.delegate = context.coordinator
        controller.preferredControlTintColor = UIColor(Color.brandAccent)
        controller.dismissButtonStyle = .close
        return controller
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onManualDismiss: onManualDismiss)
    }

    // MARK: Coordinator

    final class Coordinator: NSObject, SFSafariViewControllerDelegate {
        private let onManualDismiss: () -> Void

        init(onManualDismiss: @escaping () -> Void) {
            self.onManualDismiss = onManualDismiss
        }

        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            onManualDismiss()
        }
    }
}

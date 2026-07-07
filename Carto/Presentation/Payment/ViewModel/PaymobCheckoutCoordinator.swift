//
//  PaymobCheckoutCoordinator.swift
//  Carto
//
//  Created by Mohamed Ayman on 05/07/2026.
//  Updated on 06/07/2026: orchestrates the Intention flow —
//  create Intention → get clientSecret/publicKey → present the SDK.
//
//  (This file was exported as "File.swift" but its own header always named
//  it PaymobCheckoutCoordinator.swift — renamed to match.)
//

import UIKit

@MainActor
final class PaymobCheckoutCoordinator {

    private let remoteDataSource: PaymobRemoteDataSource
    private let sdkPresenter: PaymobCheckoutPresenting

    init(
        remoteDataSource: PaymobRemoteDataSource = PaymobAPIRemoteDataSource(),
        sdkPresenter: PaymobCheckoutPresenting?
    ) {
        self.remoteDataSource = remoteDataSource
        self.sdkPresenter = PaymobSDKAdapter()
    }

    func pay(cart: CartModel, billing: PaymobBillingData) async -> PaymobCheckoutResult {
        do {
            let amountCents = Self.amountInCents(cart.total)
            let items = cart.lines.map {
                PaymobOrderItem(name: $0.productTitle, amount_cents: Self.amountInCents($0.price), quantity: $0.quantity)
            }

            let intention = try await remoteDataSource.createIntention(
                amountCents: amountCents,
                currency: "EGP",
                merchantOrderId: "\(cart.id)-\(UUID().uuidString)",
                items: items,
                billing: billing
            )

            guard let presenter = UIApplication.topMostViewController() else {
                return .failure("Unable to find a view controller to present Paymob checkout.")
            }

            return await sdkPresenter.presentCheckout(
                clientSecret: intention.clientSecret,
                publicKey: intention.publicKey,
                from: presenter
            )
        } catch {
            return .failure(error.localizedDescription)
        }
    }

    private static func amountInCents(_ amount: String) -> Int {
        guard let decimal = Decimal(string: amount) else { return 0 }
        return Int(truncating: (decimal * 100) as NSDecimalNumber)
    }
}

extension UIApplication {
    static func topMostViewController() -> UIViewController? {
        guard let root = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
            .first?.rootViewController else { return nil }

        var top = root
        while let presented = top.presentedViewController {
            top = presented
        }
        return top
    }
}

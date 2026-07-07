//
//  CheckoutViewModel.swift
//  Carto
//
//  Created by Mohamed Ayman on 05/07/2026.
//

import Foundation

@MainActor
final class PaymentViewModel: ObservableObject {

    // MARK: - Phase

    enum Phase: Equatable {
        case reviewing
        case processingPaymob
        case creatingOrder
        case success(AdminOrder)
        case failed(String)

        static func == (lhs: Phase, rhs: Phase) -> Bool {
            switch (lhs, rhs) {
            case (.reviewing, .reviewing), (.processingPaymob, .processingPaymob), (.creatingOrder, .creatingOrder):
                return true
            case (.success(let a), .success(let b)):
                return a.id == b.id
            case (.failed(let a), .failed(let b)):
                return a == b
            default:
                return false
            }
        }
    }

    // MARK: - Published State

    @Published private(set) var phase: Phase = .reviewing
    @Published var selectedPaymentMethod: PaymentMethod = .cashOnDelivery
    @Published private(set) var completedOrder: AdminOrder?
    @Published private(set) var lastPaymentMethodUsed: PaymentMethod?

    // MARK: - Injected Cart (never re-fetched)

    let cart: CartModel

    // MARK: - Dependencies

    private let adminOrderDataSource: AdminOrderRemoteDataSource
    private let paymobCoordinator: PaymobCheckoutCoordinator
    private let billingProvider: () -> PaymobBillingData

    init(
        cart: CartModel,
        adminOrderDataSource: AdminOrderRemoteDataSource = ShopifyAdminOrderRemoteDataSource(),
        paymobCoordinator: PaymobCheckoutCoordinator?,
        billingProvider: @escaping () -> PaymobBillingData = placeholderBilling
    ) {
        self.cart = cart
        self.adminOrderDataSource = adminOrderDataSource
        self.paymobCoordinator = paymobCoordinator ?? PaymobCheckoutCoordinator(remoteDataSource: PaymobAPIRemoteDataSource(), sdkPresenter: PaymobSDKAdapter())
        self.billingProvider = billingProvider
    }

    // MARK: - Derived Display Values (all real, sourced from cart)

    var itemCount: Int {
        cart.lines.reduce(0) { $0 + $1.quantity }
    }

    var subtotalFormatted: String {
        CurrencyFormatter.format(cart.subtotal, currencyCode: cart.currencyCode)
    }

    var taxFormatted: String? {
        cart.tax.map { CurrencyFormatter.format($0, currencyCode: cart.currencyCode) }
    }

    var totalFormatted: String {
        CurrencyFormatter.format(cart.total, currencyCode: cart.currencyCode)
    }

    let shippingLabel = "Free"

    var isProcessing: Bool {
        phase == .processingPaymob || phase == .creatingOrder
    }

    // MARK: - Actions

    func placeOrder() async {
        switch selectedPaymentMethod {
        case .cashOnDelivery:
            await createShopifyOrder(isPaid: false, paymentMethod: .cashOnDelivery)

        case .paymob:
            phase = .processingPaymob
            let result = await paymobCoordinator.pay(cart: cart, billing: billingProvider())

            switch result {
            case .success:
                await createShopifyOrder(isPaid: true, paymentMethod: .paymob)
            case .failure(let message):
                phase = .failed(message)
            case .cancelled:
                phase = .reviewing
            }
        }
    }

    func retry() {
        phase = .reviewing
    }

    // MARK: - Private

    private func createShopifyOrder(isPaid: Bool, paymentMethod: PaymentMethod) async {
        phase = .creatingOrder
        do {
            let order = try await adminOrderDataSource.createOrder(
                cart: cart,
                paymentMethod: paymentMethod,
                isPaid: isPaid
            )
            completedOrder = order
            lastPaymentMethodUsed = paymentMethod
            phase = .success(order)
        } catch {
            phase = .failed(error.localizedDescription)
        }
    }

    /// Placeholder billing data for Paymob — replace with real customer
    /// info (name/email/phone/address) once wired to your Customer/Address
    /// data sources.
   
}

private func placeholderBilling() -> PaymobBillingData {
    PaymobBillingData(
        first_name: "NA", last_name: "NA", email: "guest@example.com",
        phone_number: "NA", apartment: "NA", floor: "NA", street: "NA",
        building: "NA", shipping_method: "NA", postal_code: "NA",
        city: "NA", country: "NA", state: "NA"
    )
}

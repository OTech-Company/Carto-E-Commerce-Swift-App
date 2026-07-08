//
//  PaymentViewModel.swift
//  Carto
//
//  Created by Mohamed Ayman on 05/07/2026.
//

import Foundation

@MainActor
final class PaymentViewModel: ObservableObject {

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

    @Published private(set) var phase: Phase = .reviewing
    @Published var selectedPaymentMethod: PaymentMethod = .cashOnDelivery
    @Published private(set) var completedOrder: AdminOrder?
    @Published private(set) var lastPaymentMethodUsed: PaymentMethod?

    @Published private(set) var addresses: [CustomerAddress] = []
    @Published var selectedAddress: CustomerAddress?
    @Published private(set) var isLoadingAddresses = false
    @Published var addressError: String?

    let cart: CartModel

    private let orderRepository: OrderRepositoryProtocol
    private let paymobCoordinator: PaymobCheckoutCoordinator
    private let addressRepo: AddressRepoProtocol

    private var customerAccessToken: String? {
        AuthSession.shared.currentUser?.customerAccessToken
    }

    init(
        cart: CartModel,
        addressRepo: AddressRepoProtocol,
        orderRepository: OrderRepositoryProtocol,
        paymobCoordinator: PaymobCheckoutCoordinator
    ) {
        self.cart = cart
        self.addressRepo = addressRepo
        self.orderRepository = orderRepository
        self.paymobCoordinator = paymobCoordinator
    }

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

    var canPlaceOrder: Bool {
        selectedAddress != nil && !isProcessing
    }

    func loadAddresses() async {
        guard let token = customerAccessToken else {
            addressError = "Please sign in to manage addresses."
            return
        }

        isLoadingAddresses = true
        addressError = nil

        do {
            addresses = try await addressRepo.getAllAddresses(for: token)
            if selectedAddress == nil {
                selectedAddress = addresses.first(where: { $0.isDefault }) ?? addresses.first
            }
        } catch {
            addressError = error.localizedDescription
        }

        isLoadingAddresses = false
    }

    func selectAddress(_ address: CustomerAddress) {
        selectedAddress = address
    }

    func addAddress(_ address: CustomerAddress) async {
        guard let token = customerAccessToken else { return }

        do {
            let created = try await addressRepo.addAddress(address, for: token)
            await loadAddresses()
            selectedAddress = created
        } catch {
            addressError = error.localizedDescription
        }
    }

    func editAddress(id: String, address: CustomerAddress) async {
        guard let token = customerAccessToken else { return }

        do {
            let updated = try await addressRepo.updateAddress(for: token, addressID: id, address: address)
            await loadAddresses()
            selectedAddress = updated
        } catch {
            addressError = error.localizedDescription
        }
    }

    func placeOrder() async {
        guard let address = selectedAddress else {
            phase = .failed(PaymentError.missingShippingAddress.localizedDescription)
            return
        }

        let billing = buildBillingData(from: address)

        switch selectedPaymentMethod {
        case .cashOnDelivery:
            await createShopifyOrder(isPaid: false, paymentMethod: .cashOnDelivery)

        case .paymob:
            phase = .processingPaymob
            let result = await paymobCoordinator.pay(cart: cart, billing: billing)

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

    private func createShopifyOrder(isPaid: Bool, paymentMethod: PaymentMethod) async {
        phase = .creatingOrder
        do {
            let order = try await orderRepository.createOrder(
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

    private func buildBillingData(from address: CustomerAddress) -> PaymobBillingData {
        let user = AuthSession.shared.currentUser
        return PaymobBillingData(
            first_name: address.firstName,
            last_name: address.lastName,
            email: user?.email ?? "",
            phone_number: address.phone,
            apartment: address.address2 ?? "NA",
            floor: "NA",
            street: address.address1,
            building: "NA",
            shipping_method: "NA",
            postal_code: address.zip,
            city: address.city,
            country: address.country,
            state: address.province
        )
    }
}

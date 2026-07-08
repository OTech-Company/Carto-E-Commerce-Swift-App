//
//  CartViewModel.swift
//  Carto
//
//  Created by Manona on 06/07/2026.
//

import Foundation
import Combine

@MainActor
final class CartViewModel: ObservableObject {
    @Published private(set) var cart: CartModel?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let useCase: CartUseCaseProtocol
    private let productsRepository: ProductsRepository
    private var cancellables = Set<AnyCancellable>()

    var lines: [CartLine] { cart?.lines ?? [] }
    var hasItems: Bool { !lines.isEmpty }

    var subtotal: Double { Double(cart?.subtotal ?? "0") ?? 0 }
    var total: Double { Double(cart?.total ?? "0") ?? 0 }
    var tax: Double { Double(cart?.tax ?? "0") ?? 0 }
    var checkoutURL: URL? { cart.flatMap { URL(string: $0.checkoutURL) } }

    init(useCase: CartUseCaseProtocol, productsRepository: ProductsRepository, store: CartStateStore = .shared) {
        self.useCase = useCase
        self.productsRepository = productsRepository

        store.$cart
            .receive(on: DispatchQueue.main)
            .assign(to: &$cart)

        Task { await loadCart() }
    }

    func fetchProduct(for line: CartLine) async -> Product? {
        isLoading = true
        defer { isLoading = false }
        do {
            let product = try await productsRepository.getProductInfo(productId: line.productId)
            return product
        } catch {
            print("Failed to load product: \(error)")
            errorMessage = "Could not load product details."
            return nil
        }
    }

    func loadCart() async {
        isLoading = true
        do {
            _ = try await useCase.fetchCart()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func increment(_ line: CartLine) {
        Task {
            isLoading = true
            do { _ = try await useCase.incrementLine(line) }
            catch { errorMessage = error.localizedDescription }
            isLoading = false
        }
    }

    func decrement(_ line: CartLine) {
        Task {
            isLoading = true
            do { _ = try await useCase.decrementLine(line) }
            catch { errorMessage = error.localizedDescription }
            isLoading = false
        }
    }

    func remove(_ line: CartLine) {
        Task {
            isLoading = true
            do { _ = try await useCase.removeLine(lineId: line.id) }
            catch { errorMessage = error.localizedDescription }
            isLoading = false
        }
    }

    func applyDiscount(code: String) {
        Task {
            isLoading = true
            do { _ = try await useCase.applyDiscount(code: code) }
            catch { errorMessage = error.localizedDescription }
            isLoading = false
        }
    }

    func removeDiscount() {
        Task {
            isLoading = true
            do { _ = try await useCase.removeDiscount() }
            catch { errorMessage = error.localizedDescription }
            isLoading = false
        }
    }
}

//
//  ContentView.swift
//  Carto
//
//  Created by Mohamed Ayman on 27/06/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            makeHomeScreen()
                .tabItem { Label("home", systemImage: "house.fill") }
            
            makeCategoryListScreen()
                .tabItem { Label("categories", systemImage: "square.grid.2x2.fill") }
            
            makeFavoritesScreen()
                .tabItem { Label("favorites", systemImage: "heart.fill") }
            
            makeProfileScreen()
                .tabItem { Label("profile", systemImage: "person.fill") }
        }
        .tint(Color("PrimaryColor"))
        .onAppear {
            Task {
                _ = try? await DIContainer.shared.cartRepository.fetchCart()
            }
        }
    }
    
    // MARK: - Tab Factories
    @ViewBuilder @MainActor
    private func makeHomeScreen() -> some View {
        HomeView()
            .withRouter { (route: AppRoute) in
                routeDestination(for: route)
            }
    }

    @ViewBuilder @MainActor
    private func makeFavoritesScreen() -> some View {
        FavoritesView(
            viewModel: DIContainer.shared.makeFavoritesViewModel()
        )
    }
}

extension ContentView {
    @MainActor @ViewBuilder
    func makeCategoryListScreen() -> some View {
        let repository = ServiceLocator.shared.resolveCategoryRepository()
        let useCase = GetCategoryUseCase(repository: repository)
        let viewModel = CategoryListViewModel(getCategoryUseCase: useCase, fetchSubcategoriesUseCase: useCase)
        
        CategoryListView(viewModel: viewModel)
            .withRouter {  (route: AppRoute) in
                routeDestination(for: route)
            }
    }

    @ViewBuilder @MainActor
    func makeProfileScreen() -> some View {
        ProfileView()
            .withRouter { route in
                routeDestination(for: route)
            }
    }

    @MainActor
    private func routeDestination(for route: AppRoute) -> AnyView {
        switch route {
        case .brands:
            return AnyView(BrandsScreen(
                viewModel: HomeBrandsViewModel(useCase: DIContainer.shared.makeBrandsUseCase())
            ))
            
        case .brandProducts(let brandId, let brandName):
            return AnyView(ProductsView(
                brandID: brandId,
                viewModel: DIContainer.shared.makeCategoryProductViewModel()
            )
            .navigationTitle(brandName))
            
        case .categoryProducts(let categoryId, let categoryName):
            return AnyView(ProductsView(
                categoryId: categoryId,
                viewModel: DIContainer.shared.makeCategoryProductViewModel()
            )
            .navigationTitle(categoryName))
            
        case .productDetails(let product):
            return AnyView(
                ProductsInfoView(
                    viewModel: DIContainer.shared.makeProductsInfoViewModel(product: product)
                )
            )
            
        case .addresses:
            return AnyView(AddressView())
            
        case .settings:
            return AnyView(SettingsView())
            
        case .orderHistory:
            return AnyView(makeOrderHistoryScreen())
            
        case .aboutUs:
            return AnyView(AboutUsView())
            
        case .cart:
            return AnyView(CartView(viewModel: DIContainer.shared.makeCartViewModel()))
            
        case .payment(let cart):
            return AnyView(PaymentView(viewModel: DIContainer.shared.makePaymentViewModel(cart: cart)))
            
        case .aiChat:
            let aiRepository = DIContainer.shared.makeAIRepo()
            let runShoppingAssistantUseCase = RunShoppingAssistantUseCase(repository: aiRepository)
            
            return AnyView(
                CartoAIAssistantView(runShoppingAssistantUseCase: runShoppingAssistantUseCase)
                    .toolbar(.hidden, for: .navigationBar)
            )
            
        case .aiComparison:
            let aiRepo = DIContainer.shared.makeAIRepo()
            let productRepo = DIContainer.shared.makeProductRepo()
            
            let runComparisonUseCaseInstance = CompareProductsUseCase(repository: aiRepo)
            let structuralProductsUseCase = ProductsUseCase(repository: productRepo)
            
            return AnyView(
                CartoAIComparisonView(
                    compareUseCase: runComparisonUseCaseInstance,
                    productsUseCase: structuralProductsUseCase
                )
                .toolbar(.hidden, for: .navigationBar)
            )
            
        case .aiOutfit:
            let aiRepo = DIContainer.shared.makeAIRepo()
            let productRepo = DIContainer.shared.makeProductRepo()
            
            let runOutfitSuggestionsUseCase = GenerateOutfitSuggestionsUseCase(repository: aiRepo)
            let structuralProductsUseCase = ProductsUseCase(repository: productRepo)
            
            return AnyView(
                CartoAIOutfitView(
                    runOutfitSuggestionsUseCase: runOutfitSuggestionsUseCase,
                    productsUseCase: structuralProductsUseCase
                )
                .toolbar(.hidden, for: .navigationBar)
            )
            
        case .imageSearch:
            let productRepo = DIContainer.shared.makeProductRepo()
            let structuralProductsUseCase = ProductsUseCase(repository: productRepo)

            let imageSearchUsecase = DIContainer.shared
                .makeFindSimilarProductFromImageUseCase()

            return AnyView(
                ImageSearchView(
                    findSimilarProductUseCase: imageSearchUsecase,
                    productUseCase: structuralProductsUseCase
                )
                .toolbar(.hidden, for: .navigationBar)
            )
        }
    }
    
    @MainActor
    func makeOrderHistoryScreen() -> some View {
        let repository = ServiceLocator.shared.resolveOrderRepository()
        let useCase = GetOrderHistoryUseCase(repository: repository)
        let viewModel = OrderHistoryViewModel(getOrderHistoryUseCase: useCase)

        return OrderHistoryView(viewModel: viewModel)
    }
}

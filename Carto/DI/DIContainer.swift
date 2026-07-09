//
//  DIContainer.swift
//  Carto
//
//  Created by Mohamed Ayman on 30/06/2026.
//

import Foundation

@MainActor
final class DIContainer {
    static let shared = DIContainer()

    // MARK: - Core & Auth Properties
    let authRepository: AuthenticationRepositoryProtocol
    let validator: AuthValidatorProtocol
    let appViewModel: AppViewModel
    
    // MARK: - Feature Data Sources
    let brandRemoteDataSource: BrandRemoteDataSourceProtocol
    let productRemoteDataSource: ProductsRemoteDataSource
    let addressRemoteDataSource: AddressRemoteDataSource
    let favoritesLocalDataSource: FavoritesLocalDataSourceProtocol
    let favoritesRemoteDataSource: FavoritesRemoteDataSourceProtocol
    let imageSearchRepository: ImageSearchRepository
    
    private init() {
        imageSearchRepository = ImageSearchRepositoryImpl()
        authRepository = AuthenticationRepositoryImpl()
        validator = AuthValidatorImpl()
        brandRemoteDataSource = BrandRemoteDataSource()
        productRemoteDataSource = ProductsRemoteDataSourceImpl()
        appViewModel = AppViewModel()
        addressRemoteDataSource = AddressGraphQLRemoteDataSource()
        favoritesLocalDataSource = FavoritesLocalDataSource()
        favoritesRemoteDataSource = FavoritesRemoteDataSource()
    }

    // MARK: - Shared State Accessors
    var sharedCartViewModel: CartViewModel {
        makeCartViewModel()
    }

    // MARK: - Auth Feature
    func makeLoginViewModel(router: AuthRouter) -> AuthLoginViewModel {
        AuthLoginViewModel(
            validator: validator,
            repository: authRepository,
            router: router
        )
    }
    
    func makeRegisterViewModel(router: AuthRouter) -> AuthRegisterViewModel {
        AuthRegisterViewModel(
            validator: validator,
            repository: authRepository,
            router: router
        )
    }

    func makeVerificationViewModel(userEmail: String, router: AuthRouter) -> VerificationViewModel {
        VerificationViewModel(
            userEmail: userEmail,
            repository: authRepository,
            router: router
        )
    }

    func makeForgotPasswordViewModel(router: AuthRouter) -> ForgotPasswordViewModel {
        ForgotPasswordViewModel(
            validator: validator,
            repository: authRepository,
            router: router
        )
    }
    
    // MARK: - Brands Feature
    func makeBrandsRepo() -> BrandsRepoProtocol {
        BrandsRepoImpl(remoteDataSource: brandRemoteDataSource)
    }
    
    func makeBrandsUseCase() -> BrandsUseCaseProtocol {
        BrandsUseCase(repository: makeBrandsRepo())
    }
    
    // MARK: - Home Feature
    func makeHomeProductsViewModel() -> HomeProductsViewModel {
        HomeProductsViewModel(useCase: makeProductsUseCase())
    }
    
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(
            brandVM: HomeBrandsViewModel(useCase: makeBrandsUseCase()),
            productVM: makeHomeProductsViewModel()
        )
    }

    // MARK: - Products Feature
    func makeProductRepo() -> ProductsRepository {
        ProductsRepositoryImpl(remoteDataSource: productRemoteDataSource)
    }

    func makeProductsUseCase() -> ProductUseCaseProtocol {
        ProductsUseCase(repository: makeProductRepo())
    }

    func makeCategoryProductViewModel() -> ProductsViewModel {
        ProductsViewModel(
            getCategoryUseCase: GetCategoryUseCase(
                repository: CategoryRepositoryImpl()
            ),
            getProductByBrand: makeProductsUseCase()
        )
    }

    // MARK: - Address Feature
    func makeAddressRepo() -> AddressRepoProtocol {
        AddressRepoImpl(remoteDataSource: addressRemoteDataSource)
    }

    func makeAddressViewModel() -> AddressViewModel {
        AddressViewModel(repo: makeAddressRepo())
    }
    
    // MARK: - Favorites Feature
    private(set) lazy var favoritesRepository: FavoritesRepository = {
        let repo = FavoritesRepositoryImpl(
            local: favoritesLocalDataSource,
            remote: favoritesRemoteDataSource,
            currentUserId: { AuthSession.shared.currentUser?.uid }
        )
        repo.bootstrapStore()
        return repo
    }()

    func makeFavoritesViewModel() -> FavoritesViewModel {
        FavoritesViewModel(repository: favoritesRepository)
    }

    func makeProductsInfoViewModel(product: Product) -> ProductsInfoViewModel {
        ProductsInfoViewModel(
            product: product,
            favoritesRepository: favoritesRepository,
            cartUseCase: makeCartUseCase()
        )
    }
    
    // MARK: - AI Feature Injection Dependencies
    func makeAIRepo() -> AIRepository {
        let client = GroqClient(apiKey: AppEnvironment.groqApiKey)
        let aiRepository = AIRepositoryImpl(client: client)
        return aiRepository
    }
    
    func makeCompareProductsUseCase() -> CompareProductsUseCase {
        CompareProductsUseCase(repository: makeAIRepo())
    }
    
    func makeFindSimilarProductFromImageUseCase() -> FindSimilarProductFromImageUseCase {
        FindSimilarProductFromImageUseCaseImpl(
            repository: imageSearchRepository
        )
    }
    
    // MARK: - Cart Feature
    private(set) lazy var cartRepository: CartRepository = {
        CartRepositoryImpl(remote: CartGraphQLRemoteDataSource())
    }()

    func makeCartUseCase() -> CartUseCaseProtocol {
        CartUseCase(repository: cartRepository)
    }

    func makeCartViewModel() -> CartViewModel {
        CartViewModel(
            useCase: makeCartUseCase(),
            productsRepository: makeProductRepo()
        )
    }

    // MARK: - Payment & Checkout Feature
    func makePaymobRepository() -> PaymobRepositoryProtocol {
        PaymobRepositoryImpl()
    }

    func makePaymobCheckoutCoordinator() -> PaymobCheckoutCoordinator {
        PaymobCheckoutCoordinator(repository: makePaymobRepository())
    }

    func makePaymentViewModel(cart: CartModel) -> PaymentViewModel {
        PaymentViewModel(
            cart: cart,
            addressRepo: makeAddressRepo(),
            orderRepository: ServiceLocator.shared.resolveOrderRepository(),
            paymobCoordinator: makePaymobCheckoutCoordinator()
        )
    }

    func makeProductCardViewModel(product: Product) -> ProductCardViewModel {
        ProductCardViewModel(
            product: product,
            repository: favoritesRepository,
            cartUseCase: makeCartUseCase()
        )
    }
    
    func makeProfileViewModel() -> ProfileViewModel {
        ProfileViewModel(authRepo: authRepository)
    }
}

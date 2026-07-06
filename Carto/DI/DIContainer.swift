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

    let authRepository: AuthenticationRepositoryProtocol
    let authSession: AuthSession
    let validator: AuthValidatorProtocol
    let appViewModel: AppViewModel
    let brandRemoteDataSource: BrandRemoteDataSourceProtocol
    let productRemoteDataSource: ProductsRemoteDataSource
    let favoritesLocalDataSource: FavoritesLocalDataSourceProtocol
    let favoritesRemoteDataSource: FavoritesRemoteDataSourceProtocol
    let cartLocalDataSource: CartLocalDataSourceProtocol
    let cartRemoteDataSource: CartFirestoreRemoteDataSourceProtocol

    private init() {
        authRepository = AuthenticationRepositoryImpl()
        authSession = AuthSession()
        validator = AuthValidatorImpl()
        brandRemoteDataSource = BrandRemoteDataSource()
        productRemoteDataSource = ProductsRemoteDataSourceImpl()
        appViewModel = AppViewModel(authSession: authSession)
        favoritesLocalDataSource = FavoritesLocalDataSource()
        favoritesRemoteDataSource = FavoritesRemoteDataSource()
        cartLocalDataSource = CartLocalDataSource()
        cartRemoteDataSource = CartFirestoreRemoteDataSource()
    }

    func makeLoginViewModel(router: AuthRouter) -> AuthLoginViewModel {
        AuthLoginViewModel(
            validator: validator,
            repository: authRepository,
            authSession: authSession,
            router: router
        )
    }

    func makeRegisterViewModel(router: AuthRouter) -> AuthRegisterViewModel {
        AuthRegisterViewModel(
            validator: validator,
            repository: authRepository,
            authSession: authSession,
            router: router
        )
    }

    func makeVerificationViewModel(userEmail: String, router: AuthRouter) -> VerificationViewModel {
        VerificationViewModel(
            userEmail: userEmail,
            repository: authRepository,
            authSession: authSession,
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

    func makeBrandsRepo() -> BrandsRepoProtocol {
        BrandsRepoImpl(remoteDataSource: brandRemoteDataSource)
    }

    func makeBrandsUseCase() -> BrandsUseCaseProtocol {
        BrandsUseCase(repository: makeBrandsRepo())
    }

    func makeHomeProductsViewModel() -> HomeProductsViewModel {
        HomeProductsViewModel(useCase: makeProductsUseCase())
    }

    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(
            brandVM: HomeBrandsViewModel(useCase: makeBrandsUseCase()),
            productVM: makeHomeProductsViewModel()
        )
    }

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

    private(set) lazy var favoritesRepository: FavoritesRepository = {
        let repo = FavoritesRepositoryImpl(
            local: favoritesLocalDataSource,
            remote: favoritesRemoteDataSource,
            currentUserId: { [weak self] in self?.authSession.currentUser?.uid }
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
    
    private(set) lazy var cartRepository: CartRepository = {
        let repo = CartRepositoryImpl(
            local: cartLocalDataSource,
            remote: cartRemoteDataSource,
            currentUserId: { [weak self] in self?.authSession.currentUser?.uid }
        )
        repo.bootstrapStore()
        return repo
    }()

    func makeCartUseCase() -> CartUseCaseProtocol {
        CartUseCase(repository: cartRepository)
    }

    func makeCartViewModel() -> CartViewModel {
        CartViewModel(useCase: makeCartUseCase(), repository: cartRepository)
    }

    func makeProductCardViewModel(product: Product) -> ProductCardViewModel {
        ProductCardViewModel(
            product: product,
            repository: favoritesRepository,
            cartUseCase: makeCartUseCase()
        )
    }
}

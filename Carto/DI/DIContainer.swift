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
    let authSession: AuthSession
    let validator: AuthValidatorProtocol
    let appViewModel: AppViewModel
    
    // MARK: - Feature Data Sources
    let brandRemoteDataSource: BrandRemoteDataSourceProtocol
    let productRemoteDataSource: ProductsRemoteDataSource
    let addressRemoteDataSource: AddressRemoteDataSource
    let favoritesLocalDataSource: FavoritesLocalDataSourceProtocol
    let favoritesRemoteDataSource: FavoritesRemoteDataSourceProtocol

    private init() {
        authRepository = AuthenticationRepositoryImpl()
        authSession = AuthSession()
        validator = AuthValidatorImpl()
        brandRemoteDataSource = BrandRemoteDataSource()
        productRemoteDataSource = ProductsRemoteDataSourceImpl()
        appViewModel = AppViewModel(authSession: authSession)
        addressRemoteDataSource = AddressGraphQLRemoteDataSource()
        favoritesLocalDataSource = FavoritesLocalDataSource()
        favoritesRemoteDataSource = FavoritesRemoteDataSource()
    }

    // MARK: - Auth ViewModels
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
            currentUserId: { [weak self] in self?.authSession.currentUser?.uid }
        )
        repo.bootstrapStore()
        return repo
    }

    func makeFavoritesViewModel() -> FavoritesViewModel {
        FavoritesViewModel(repository: favoritesRepository)
    }

    func makeProductCardViewModel(productId: Int) -> ProductCardViewModel {
        ProductCardViewModel(
            productId: productId,
            repository: favoritesRepository
        )
    }

    func makeProductsInfoViewModel(product: Product) -> ProductsInfoViewModel {
        ProductsInfoViewModel(
            product: product,
            repository: favoritesRepository
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
}

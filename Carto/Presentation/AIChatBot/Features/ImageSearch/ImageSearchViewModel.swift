//
//  ImageSearchViewModel.swift
//  Carto
//
//  Created by Osama Hosam on 08/07/2026.
//


import Foundation
import UIKit

@MainActor
final class ImageSearchViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published private(set) var state: LoadState<Product> = .idle

    private let findSimilarProductUseCase: FindSimilarProductFromImageUseCase
    private let productUseCase: ProductUseCaseProtocol

    init(
        findSimilarProductUseCase: FindSimilarProductFromImageUseCase,
        productUseCase: ProductUseCaseProtocol
    ) {
        self.findSimilarProductUseCase = findSimilarProductUseCase
        self.productUseCase = productUseCase
    }

    func setImage(_ image: UIImage) {
        selectedImage = image
        state = .idle
    }

    func searchForMatch() async {
        guard
            let image = selectedImage,
            let imageData = image.jpegData(compressionQuality: 0.9)
        else {
            state = .failure(ImageSearchError.invalidImage)
            return
        }

        state = .loading

        do {
            let allProducts = try await productUseCase.execute()

            guard let match = await findSimilarProductUseCase.execute(
                imageData: imageData,
                products: allProducts
            ) else {
                state = .failure(ImageSearchError.noMatchFound)
                return
            }

            state = .success(match)
        } catch {
            state = .failure(error)
        }
    }

    func reset() {
        selectedImage = nil
        state = .idle
    }
}

enum ImageSearchError: LocalizedError {
    case invalidImage
    case noMatchFound

    var errorDescription: String? {
        switch self {
        case .invalidImage: return "Couldn't process the selected image."
        case .noMatchFound: return "No matching product was found."
        }
    }
}
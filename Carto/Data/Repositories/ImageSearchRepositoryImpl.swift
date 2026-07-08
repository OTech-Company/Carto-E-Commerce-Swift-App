//
//  ImageSearchRepositoryImpl.swift
//  Carto
//
//  Created by Osama Hosam on 08/07/2026.
//

import UIKit
import Vision
import CoreML

final class ImageSearchRepositoryImpl: ImageSearchRepository {

    func findMostSimilarProduct(
        to imageData: Data,
        from products: [Product]
    ) async -> Product? {

        guard let queryImage = UIImage(data: imageData) else {
            print("❌ Couldn't create query UIImage")
            return nil
        }

        guard let queryFeature = extractFeature(from: queryImage) else {
            print("❌ Couldn't extract query feature")
            return nil
        }

        var bestProduct: Product?
        var bestDistance = Float.greatestFiniteMagnitude

        for product in products {
            print("Checking:", product.imageURL)

            guard let url = URL(string: product.imageURL) else {
                print("❌ Invalid URL")
                continue
            }

            // NOTE: still synchronous/blocking — see note below about moving to URLSession
            guard let data = try? Data(contentsOf: url) else {
                print("❌ Couldn't download image")
                continue
            }

            guard let image = UIImage(data: data) else {
                print("❌ Couldn't create UIImage")
                continue
            }

            guard let feature = extractFeature(from: image) else {
                print("❌ Couldn't extract feature")
                continue
            }

            guard let distance = distance(between: queryFeature, and: feature) else {
                continue
            }
            print("Distance:", distance)

            if distance < bestDistance {
                bestDistance = distance
                bestProduct = product
            }
        }

        print("Best distance:", bestDistance)
        return bestProduct
    }
}

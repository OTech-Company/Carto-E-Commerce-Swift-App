//
//  ImageSearchRepository.swift
//  Carto
//
//  Created by Osama Hosam on 08/07/2026.
//

import UIKit

protocol ImageSearchRepository {
    func findMostSimilarProduct(to imageData: Data,from products: [Product]) async -> Product?
}

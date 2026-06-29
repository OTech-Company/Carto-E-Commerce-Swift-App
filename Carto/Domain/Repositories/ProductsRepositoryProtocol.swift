//
//  ProductsRepositoryProtocol.swift
//  Carto
//
//  Created by Manona on 29/06/2026.
//

protocol ProductsRepositoryProtocol{
    
    func getProductInfo(productId: String) async throws -> ProductInfo

}

//
//  ProductsRepositoryProtocol.swift
//  Carto
//
//  Created by Manona on 29/06/2026.
//

protocol ProductsRepository{
        
    func getProductsByBrand(brandId: Int) async throws -> [Product]
    
    func getAllProducts() async throws -> [Product]
    
}

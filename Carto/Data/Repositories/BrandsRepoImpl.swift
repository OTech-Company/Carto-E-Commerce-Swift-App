//
//  BrandsRepoImpl.swift
//  Carto
//
//  Created by Nadin Ahmed on 01/07/2026.
//

class BrandsRepoImpl: BrandsRepoProtocol{
    private let remoteDataSource: BrandRemoteDataSourceProtocol
    
    init(remoteDataSource: BrandRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchBrands() async throws -> [BrandEntity] {
        let brandsDTO = try await remoteDataSource.fetchBrands()
        return brandsDTO.map { $0.toDomainModel() }
    }
}

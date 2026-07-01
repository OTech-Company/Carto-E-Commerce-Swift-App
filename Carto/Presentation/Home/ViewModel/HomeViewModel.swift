//
//  HomeViewModel.swift
//  Carto
//
//  Created by Nadin Ahmed on 01/07/2026.
//

import Combine
import Foundation

final class HomeViewModel: ObservableObject {
    let brandVM: HomeBrandsViewModel

    init(brandVM: HomeBrandsViewModel) {
        self.brandVM = brandVM
    }

    func loadAllData() async {
        async let brands: () = brandVM.loadBrands()
        _ = await brands
    }
}

//
//  CartoApp.swift
//  Carto
//
//  Created by Mohamed Ayman on 27/06/2026.
//

import SwiftUI

@main
struct CartoApp: App {
    init() {
        let container = AppContainer()
        ServiceLocator.shared.register(container: container)
    }
    
    var body: some Scene {
        WindowGroup {
            ProductsInfoView(product: .mock)
        }
    }
}

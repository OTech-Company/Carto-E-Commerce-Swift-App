//
//  RouterViewModifier.swift
//  Carto
//
//  Created by Osama Hosam on 05/07/2026.
//
import SwiftUI

public struct RouterViewModifier<Route: Hashable & Identifiable, Destination: View>: ViewModifier {

    @StateObject private var router = Router<Route>()
    private let destinationFactory: (Route) -> Destination
    
    public init(@ViewBuilder destinationFactory: @escaping (Route) -> Destination) {
        self.destinationFactory = destinationFactory
    }
    
    public func body(content: Content) -> some View {
        NavigationStack(path: $router.path) {
            content
                .environmentObject(router) // Use environmentObject
                .navigationDestination(for: Route.self) { route in
                    destinationFactory(route)
                        .environmentObject(router)
                }
                .sheet(item: $router.sheetDestination) { route in // Standard binding syntax replaces Bindable
                    NavigationStack {
                        destinationFactory(route)
                            .environmentObject(router)
                    }
                }
        }
        .environmentObject(router)
    }
}

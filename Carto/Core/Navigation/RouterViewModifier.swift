//
//  RouterViewModifier.swift
//  Carto
//
//  Created by Osama Hosam on 05/07/2026.
//
import SwiftUI

@available(iOS 17.0, *)
public struct RouterViewModifier<Route: Hashable & Identifiable, Destination: View>: ViewModifier {
    @State private var router = Router<Route>()
    private let destinationFactory: (Route) -> Destination
    
    public init(@ViewBuilder destinationFactory: @escaping (Route) -> Destination) {
        self.destinationFactory = destinationFactory
    }
    
    public func body(content: Content) -> some View {
        NavigationStack(path: $router.path) {
            content
                .environment(router)
                .navigationDestination(for: Route.self) { route in
                    destinationFactory(route)
                }
                .sheet(item: Bindable(router).sheetDestination) { route in
                    NavigationStack {
                        destinationFactory(route)
                    }
                }
        }
    }
}

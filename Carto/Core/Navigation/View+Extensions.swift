//
//  View+Extensions.swift
//  Carto
//
//  Created by Osama Hosam on 05/07/2026.
//

import SwiftUI

extension View {
    @available(iOS 17.0, *)
    public func withRouter<Route: Hashable & Identifiable, Destination: View>(
        @ViewBuilder routingFactory: @escaping (Route) -> Destination
    ) -> some View {
        self.modifier(RouterViewModifier(destinationFactory: routingFactory))
    }
}

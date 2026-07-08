//
//  Router.swift
//  Carto
//
//  Created by Osama Hosam on 05/07/2026.
//
import Foundation
import SwiftUI

public class Router<Route: Hashable & Identifiable>: ObservableObject {
    @Published public var path = NavigationPath()
    @Published public var sheetDestination: Route?
    
    public init() {}
    
    public func push(to route: Route) {
        path.append(route)
    }
    
    public func present(_ route: Route) {
        sheetDestination = route
    }
    
    public func dismiss() {
        sheetDestination = nil
    }
    
    public func popToRoot() {
        guard !path.isEmpty else { return }
        path.removeLast(path.count)
    }
}

//
//  Router.swift
//  Carto
//
//  Created by Osama Hosam on 05/07/2026.
//
import Foundation
import SwiftUI
import Observation

@available(iOS 17.0, *)
@Observable
public class Router<Route: Hashable & Identifiable> { 
    public var path = NavigationPath()
    
    public var sheetDestination: Route?
    
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
        path.removeLast(path.count)
    }
}

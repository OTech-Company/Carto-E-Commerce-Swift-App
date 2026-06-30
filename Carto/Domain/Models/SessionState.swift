//
//  SessionState.swift
//  Carto
//
//  Created by Mohamed Ayman on 30/06/2026.
//

import Foundation

enum SessionState {
    case unauthenticated
    case guest
    case authenticated(User)
}

extension SessionState {

    // MARK: - Privileges

    var canAddToCart: Bool {
        switch self {
        case .unauthenticated: return false
        case .guest:           return true
        case .authenticated:   return true
        }
    }

    var canCheckout: Bool {
        switch self {
        case .unauthenticated, .guest: return false
        case .authenticated:           return true
        }
    }

    var canWriteReview: Bool {
        switch self {
        case .unauthenticated, .guest: return false
        case .authenticated:           return true
        }
    }

    var canSaveWishlist: Bool {
        switch self {
        case .unauthenticated, .guest: return false
        case .authenticated:           return true
        }
    }

    // MARK: - Helpers

    var isAuthenticated: Bool {
        guard case .authenticated = self else { return false }
        return true
    }

    var user: User? {
        guard case .authenticated(let user) = self else { return nil }
        return user
    }
}

//
//  GuestSessionStore.swift
//  Carto
//
//  Created by Mohamed Ayman on 30/06/2026.
//

import Foundation

final class GuestSessionStore: GuestSessionStoreProtocol {

    private let key = "carto.isGuestSession"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var isGuest: Bool {
        defaults.bool(forKey: key)
    }

    @MainActor
    func setGuest(_ isGuest: Bool) async {
        let authSession: AuthSession = DIContainer.shared.authSession
        
        defaults.set(isGuest, forKey: key)
        await authSession.refreshSession()
    }
}

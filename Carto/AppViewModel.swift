//
//  AppViewModel.swift
//  Carto
//
//  Created by Mohamed Ayman on 30/06/2026.
//

import Foundation

@MainActor
final class AppViewModel: ObservableObject {

    @Published private(set) var sessionState: SessionState = .unauthenticated

    private let repository: AuthenticationRepositoryProtocol

    init(repository: AuthenticationRepositoryProtocol) {
        self.repository = repository
    }

    func restoreSession() async {
        sessionState = await repository.restoreSession()
    }
}

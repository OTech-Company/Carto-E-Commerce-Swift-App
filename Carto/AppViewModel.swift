//
//  AppViewModel.swift
//  Carto
//
//  Created by Mohamed Ayman on 30/06/2026.
//

import Foundation

@MainActor
final class AppViewModel: ObservableObject {

    @Published private(set) var sessionState: SessionState = .loading

    private let repository: AuthenticationRepositoryProtocol

    init(repository: AuthenticationRepositoryProtocol) {
        self.repository = repository
        Task{
            try await Task.sleep(nanoseconds: 3_000_000_000)
            await restoreSession()
        }
    }

    func restoreSession() async {
        sessionState = await repository.restoreSession()
    }
}

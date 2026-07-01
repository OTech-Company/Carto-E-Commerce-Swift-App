//
//  AppViewModel.swift
//  Carto
//
//  Created by Mohamed Ayman on 30/06/2026.
//

import Foundation
import Combine

@MainActor
final class AppViewModel: ObservableObject {

    @Published private(set) var sessionState: SessionState = .loading

    private var cancellables = Set<AnyCancellable>()
    private let authSession: AuthSession

    init(authSession: AuthSession) {
        self.authSession = authSession
        authSession.sessionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sessionState in
                self?.sessionState = sessionState
            }
            .store(in: &cancellables)
    }
}

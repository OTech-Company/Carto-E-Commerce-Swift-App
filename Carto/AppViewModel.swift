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
    private var isSplashFinished = false
    private var latestAuthState: SessionState = .unauthenticated

    private var cancellables = Set<AnyCancellable>()
    private let authSession: AuthSession

    init() {
        self.authSession = AuthSession.shared
        
        authSession.sessionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                self.latestAuthState = state
                
                if self.isSplashFinished && self.sessionState != .onboarding {
                    self.sessionState = state
                }
            }
            .store(in: &cancellables)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) { [weak self] in
            guard let self = self else { return }
            self.isSplashFinished = true
            
            let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
            if !hasSeenOnboarding {
                self.sessionState = .onboarding
            } else {
                self.sessionState = self.latestAuthState
            }
        }
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        self.sessionState = self.latestAuthState
    }
}

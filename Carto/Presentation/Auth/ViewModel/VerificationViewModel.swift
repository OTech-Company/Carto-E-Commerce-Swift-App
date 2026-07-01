//
//  VerificationViewModel.swift
//  Carto
//
//  Created by Mohamed Ayman on 30/06/2026.
//

import Foundation

@MainActor
final class VerificationViewModel: ObservableObject {

    @Published var userEmail: String
    @Published var isLoading = false
    @Published var warningMessage: String?
    

    @Published private(set) var countdownValue = 60
    @Published private(set) var isResendDisabled = false
    
    private var timer: Timer?
    private let repository: AuthenticationRepositoryProtocol
    private let appViewModel: AppViewModel
    private let router: AuthRouter

    init(
        userEmail: String,
        repository: AuthenticationRepositoryProtocol,
        appViewModel: AppViewModel,
        router: AuthRouter
    ) {
        self.userEmail = userEmail
        self.repository = repository
        self.appViewModel = appViewModel
        self.router = router
    }

    func checkVerificationStatus() {
        isLoading = true
        warningMessage = nil

        Task {
            let isVerified = await repository.checkEmailVerified()

            if isVerified {
                await appViewModel.restoreSession()
                router.showVerificationSuccess()
            } else {
                warningMessage = "Your email hasn't been verified yet."
            }
            isLoading = false
        }
    }

    func resendVerificationEmail() {
        warningMessage = nil

        Task {
            do {
                try await repository.sendEmailVerification()
                startResendCountdown()
            } catch let error as AuthError {
                warningMessage = error.errorDescription
            } catch {
                warningMessage = "Couldn't resend the email. Please try again."
            }
        }
    }

    private func startResendCountdown() {
        countdownValue = 60
        isResendDisabled = true

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                if self.countdownValue > 1 {
                    self.countdownValue -= 1
                } else {
                    self.stopTimer()
                }
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        isResendDisabled = false
    }
    
    func goBack() {
        router.pop()
    }

    deinit {
        timer?.invalidate()
    }
}

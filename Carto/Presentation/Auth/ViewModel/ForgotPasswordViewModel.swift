//
//  ForgotPasswordViewModel.swift
//  Carto
//
//  Created by Mohamed Ayman on 01/07/2026.
//

import Foundation

@MainActor
final class ForgotPasswordViewModel: ObservableObject {

    @Published var email = ""
    @Published var emailErrorMessage: String?
    @Published var generalErrorMessage: String?
    @Published private(set) var isLoading = false

    var isResetEnabled: Bool {
        !email.isEmpty && emailErrorMessage == nil
    }

    private let validator: AuthValidatorProtocol
    private let repository: AuthenticationRepositoryProtocol
    private let router: AuthRouter

    init(
        validator: AuthValidatorProtocol,
        repository: AuthenticationRepositoryProtocol,
        router: AuthRouter
    ) {
        self.validator = validator
        self.repository = repository
        self.router = router
    }

    func validateEmail() {
        do {
            try validator.validateEmail(email: email)
            emailErrorMessage = nil
        } catch let validationError as AuthValidationError {
            emailErrorMessage = validationError.localizedDescription
        } catch {
            emailErrorMessage = "Something went wrong."
        }
    }

    func sendResetLink() {
        validateEmail()
        guard isResetEnabled else { return }

        isLoading = true
        generalErrorMessage = nil

        Task {
            do {
                try await repository.sendPasswordReset(email: email)
                router.showForgotPasswordSuccess()
            } catch let error as AuthError {
                generalErrorMessage = error.errorDescription
            } catch {
                generalErrorMessage = "Could not process request. Please try again."
            }
            isLoading = false
        }
    }

    func navigateToSignIn() {
        router.showLogin()
    }
}

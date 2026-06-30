//
//  AuthLoginViewModel.swift
//  Carto
//
//  Created by Mohamed Ayman on 27/06/2026.
//

import Foundation

@MainActor
final class AuthLoginViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var email = ""
    @Published var password = ""
    @Published var emailErrorMessage: String?
    @Published var passwordErrorMessage: String?

    @Published private(set) var isLoading = false
    @Published var generalErrorMessage: String?

    var isLoginEnabled: Bool {
        !email.isEmpty &&
        !password.isEmpty &&
        emailErrorMessage == nil &&
        passwordErrorMessage == nil
    }

    // MARK: - Dependencies

    private let validator: AuthValidatorProtocol
    private let repository: AuthenticationRepositoryProtocol
    private let appViewModel: AppViewModel

    init(
        validator: AuthValidatorProtocol,
        repository: AuthenticationRepositoryProtocol,
        appViewModel: AppViewModel
    ) {
        self.validator = validator
        self.repository = repository
        self.appViewModel = appViewModel
    }

    // MARK: - Validation

    func validateEmail() {
        do {
            try validator.validateEmail(email: email)
            emailErrorMessage = nil
        } catch let validationError as AuthValidationError {
            emailErrorMessage = validationError.localizedDescription
        } catch {
            emailErrorMessage = "Something is wrong."
        }
    }

    func validatePassword() {
        do {
            try validator.validatePassword(password: password)
            passwordErrorMessage = nil
        } catch let validationError as AuthValidationError {
            passwordErrorMessage = validationError.localizedDescription
        } catch {
            passwordErrorMessage = "Something went wrong."
        }
    }

    // MARK: - Actions

    func login() {
        validateEmail()
        validatePassword()
        guard isLoginEnabled else { return }

        isLoading = true
        generalErrorMessage = nil

        Task {
            do {
                let user = try await repository.login(email: email, password: password)
                await appViewModel.restoreSession()
                print(appViewModel.sessionState.canBrowseProducts)
                print(appViewModel.sessionState.canWriteReview)
                print(user.isEmailVerified)
            } catch let error as AuthError {
                generalErrorMessage = error.errorDescription
            } catch {
                generalErrorMessage = "Something went wrong. Please try again."
            }
            isLoading = false
        }
    }

    func continueAsGuest() {
        Task{
            isLoading = true
            do {
                try await Task.sleep(for: .seconds(1))
                repository.continueAsGuest()
                await appViewModel.restoreSession()
                print(appViewModel.sessionState.canBrowseProducts)
                print(appViewModel.sessionState.canWriteReview)
                isLoading = false
            } catch {
                generalErrorMessage = error.localizedDescription
            }
        }
    }

    func signInWithGoogle() {
        //
    }
    
}

//
//  AuthLoginViewModel.swift
//  Carto
//
//  Created by Mohamed Ayman on 27/06/2026.
//

import Foundation

@MainActor
final class AuthRegisterViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    
    @Published var firstNameErrorMessage: String?
    @Published var lastNameErrorMessage: String?
    @Published var emailErrorMessage: String?
    @Published var passwordErrorMessage: String?
    @Published var generalErrorMessage: String?
    
    @Published var isLoading = false

    // MARK: - Validation

    var isRegisterEnabled: Bool {
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        !email.isEmpty &&
        !password.isEmpty &&
        firstNameErrorMessage == nil &&
        lastNameErrorMessage == nil &&
        emailErrorMessage == nil &&
        passwordErrorMessage == nil
    }

    // MARK: - Dependencies

    private let validator: AuthValidatorProtocol
    private let repository: AuthenticationRepositoryProtocol
    private let authSession: AuthSession
    private let router: AuthRouter
    
    // MARK: - Initialization
    
    init(
        validator: AuthValidatorProtocol,
        repository: AuthenticationRepositoryProtocol,
        authSession: AuthSession,
        router: AuthRouter
    ) {
        self.validator = validator
        self.repository = repository
        self.authSession = authSession
        self.router = router
    }

    func validateFirstName() {
        do {
            try validator.validateName(name: firstName)
            firstNameErrorMessage = nil
        } catch let validationError as AuthValidationError {
            firstNameErrorMessage = validationError.localizedDescription
        } catch {
            firstNameErrorMessage = "Something is wrong."
        }
    }

    func validateLastName() {
        do {
            try validator.validateName(name: lastName)
            lastNameErrorMessage = nil
        } catch let validationError as AuthValidationError {
            lastNameErrorMessage = validationError.localizedDescription
        } catch {
            lastNameErrorMessage = "Something is wrong."
        }
    }

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

    func register() {
        validateFirstName()
        validateLastName()
        validateEmail()
        validatePassword()

        guard isRegisterEnabled else { return }

        isLoading = true
        generalErrorMessage = nil

        Task {
            do {
                let input = RegisterInput(
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    password: password
                )
                _ = try await repository.register(input: input)
                try? await repository.sendEmailVerification()
                router.showVerification(email: email)
            } catch let error as AuthError {
                generalErrorMessage = error.errorDescription
                
            } catch {
                generalErrorMessage = "Something went wrong. Please try again."
            }
            isLoading = false
        }
    }

    func signInWithGoogle() {
       //
    }

    func signInWithApple() {
        //
    }

    func continueAsGuest() {
        Task {
            isLoading = true
            do {
                try await Task.sleep(for: .seconds(1))
                repository.continueAsGuest()
                isLoading = false
            } catch {
                isLoading = false
            }
        }
    }
    
    func signInTapped () {
        router.showLogin()
    }
}

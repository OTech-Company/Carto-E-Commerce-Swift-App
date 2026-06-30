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

    @Published var isLoading = false
    @Published var generalErrorMessage: String?

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
    private let appViewModel: AppViewModel
    
    // MARK: - Initialization
    
    init(
        validator: AuthValidatorProtocol,
        repository: AuthenticationRepositoryProtocol,
        appViewModel: AppViewModel
    ) {
        self.validator = validator
        self.repository = repository
        self.appViewModel = appViewModel
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
                let user = try await repository.register(input: input)
                await appViewModel.restoreSession()
                print(appViewModel.sessionState.canAddToCart)
                
            } catch let error as AuthError {
                generalErrorMessage = error.errorDescription
                
            } catch {
                generalErrorMessage = "Something went wrong. Please try again."
                isLoading = false
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
        Task{
            isLoading = true
            do {
                try await Task.sleep(for: .seconds(1))
                repository.continueAsGuest()
                await appViewModel.restoreSession()
                isLoading = false
            } catch {
                isLoading = false
            }
        }
    }
}

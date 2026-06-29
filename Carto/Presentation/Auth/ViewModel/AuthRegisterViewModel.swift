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
    
    // MARK: - Initialization
    init(validator: AuthValidatorProtocol) {
        self.validator = validator
    }


    func validateFirstName() {
        do {
            try validator.validateName(name: firstName)
        } catch let validationError as AuthValidationError {
            firstNameErrorMessage = validationError.localizedDescription
        } catch {
            firstNameErrorMessage = "Something is wrong."
        }
    }

    func validateLastName() {
        do {
            try validator.validateName(name: lastName)
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

        // Register with Firebase
    }

    func signInWithGoogle() async {
        isLoading = true

        do {
            try await Task.sleep(for: .seconds(2))

            isLoading = false
            print("Done")
        } catch {
            isLoading = false
        }
    }

    func signInWithApple() {
        // Apple Sign Up
    }
    
    func continueAsGuest() {
        // Guest Sign In
    }
}


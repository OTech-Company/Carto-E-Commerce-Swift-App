
import Foundation

@MainActor
final class AuthLoginViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var email = ""
    @Published var password = ""
    @Published var emailErrorMessage: String?
    @Published var passwordErrorMessage: String?
    
    @Published private(set) var isLoading = false
    
    var isLoginEnabled: Bool {
          !email.isEmpty &&
          !password.isEmpty &&
          emailErrorMessage == nil &&
          passwordErrorMessage == nil
      }
    
    // MARK: - Dependencies
    private let validator: AuthValidatorProtocol
    
    init(
        validator: AuthValidatorProtocol
    ) {
        self.validator = validator
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
    
    func continueAsGuest() {

    }
    
    func login() {

    }
    
    func signInWithGoogle() {
        
    }
}

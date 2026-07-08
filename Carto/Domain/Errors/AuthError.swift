import Foundation

enum AuthError: LocalizedError {
    case emailAlreadyInUse
    case invalidEmail
    case weakPassword
    case networkError
    case wrongPassword
    case userNotFound
    case userDisabled
    case tooManyRequests
    case requiresRecentLogin
    case profileUpdateFailed
    case firestoreWriteFailed
    // Google Sign-In
    case googleSignInCancelled
    case googleSignInFailed(String)
    // Shopify
    case shopifyCustomerCreationFailed(String)
    case shopifyTokenGenerationFailed(String)
    case shopifyAdminUpdateFailed(String)
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .emailAlreadyInUse:               return "This email is already registered."
        case .invalidEmail:                    return "Please enter a valid email address."
        case .weakPassword:                    return "Password must be at least 6 characters."
        case .networkError:                    return "Check your internet connection and try again."
        case .wrongPassword:                   return "Incorrect email or password."
        case .userNotFound:                    return "No account was found with this email address."
        case .userDisabled:                    return "This account has been disabled."
        case .tooManyRequests:                 return "Too many attempts. Please wait a moment and try again."
        case .requiresRecentLogin:             return "Please log in again to continue."
        case .profileUpdateFailed:             return "Account created but profile update failed."
        case .firestoreWriteFailed:            return "Account created but profile save failed."
        case .googleSignInCancelled:           return nil
        case .googleSignInFailed(let msg):     return "Google Sign-In failed: \(msg)"
        case .shopifyCustomerCreationFailed(let msg): return "Could not create your shopping profile: \(msg)"
        case .shopifyTokenGenerationFailed(let msg):  return "Could not generate your access token: \(msg)"
        case .shopifyAdminUpdateFailed(let msg):      return "Could not sync your password: \(msg)"
        case .unknown(let msg):                return msg
        }
    }
}

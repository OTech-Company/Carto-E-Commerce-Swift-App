import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noInternet
    case requestFailed(Int)        // HTTP status code
    case decodingFailed(Error)
    case unauthorized              // 401 — token expired
    case notFound                  // 404
    case serverError               // 5xx
    case graphQL([String])         // GraphQL-level errors returned in the payload
    case unknown(Error)

    var localizedDescription: String {
        switch self {
        case .invalidURL:           return "Invalid URL."
        case .noInternet:           return "No internet connection."
        case .requestFailed(let c): return "Request failed with code \(c)."
        case .decodingFailed:       return "Failed to decode response."
        case .unauthorized:         return "Session expired. Please log in again."
        case .notFound:             return "Resource not found."
        case .serverError:          return "Server error. Try again later."
        case .graphQL(let errors):  return errors.joined(separator: "\n")
        case .unknown(let e):       return e.localizedDescription
        }
    }

    // Conform to LocalizedError so `error.localizedDescription` (and errorDescription)
    // returns the user-friendly message above instead of the generic NSError text.
    var errorDescription: String? {
        return localizedDescription
    }
}

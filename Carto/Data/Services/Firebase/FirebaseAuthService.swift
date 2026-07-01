//
//  FirebaseAuthService.swift
//  Carto
//
//  Created by Mohamed Ayman on 30/06/2026.
//

import Foundation
import FirebaseAuth

final class FirebaseAuthService: FirebaseAuthServiceProtocol {

    func createUser(email: String, password: String) async throws -> FirebaseAuthUser{
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            return FirebaseAuthUser(
                uid: result.user.uid,
                email: result.user.email,
                isEmailVerified: result.user.isEmailVerified
            )
        } catch let error as NSError {
            throw mapFirebaseError(error)
        }
    }
    
    func deleteCurrentUser() async throws {

        guard let currentUser = Auth.auth().currentUser else {
            throw AuthError.unknown("No authenticated user found.")
        }

        do {
            try await currentUser.delete()
        } catch let error as NSError {
            throw mapFirebaseError(error)
        }
    }
    
    func signIn(email: String, password: String) async throws -> FirebaseAuthUser {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            return FirebaseAuthUser(
                uid: result.user.uid,
                email: result.user.email,
                isEmailVerified: result.user.isEmailVerified
            )
        } catch let error as NSError {
            throw mapFirebaseError(error)
        }
    }

    
    func updateDisplayName(name: String) async throws {
        guard let currentUser = Auth.auth().currentUser else {
            throw AuthError.unknown("No authenticated user found.")
        }
        let changeRequest = currentUser.createProfileChangeRequest()
        changeRequest.displayName = name
        do {
            try await changeRequest.commitChanges()
        } catch {
            throw AuthError.profileUpdateFailed
        }
    }

    func signOut() throws {
        do {
            try Auth.auth().signOut()
        } catch {
            throw AuthError.unknown(error.localizedDescription)
        }
    }

    func sendEmailVerification() async throws {
        guard let currentUser = Auth.auth().currentUser else {
            throw AuthError.unknown("No authenticated user found.")
        }
        do {
            try await currentUser.sendEmailVerification()
        } catch {
            throw AuthError.unknown(error.localizedDescription)
        }
    }

    // MARK: - Error mapping

    private func mapFirebaseError(_ error: NSError) -> AuthError {
        guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else {
            return .unknown(error.localizedDescription)
        }
        switch errorCode {
        case .emailAlreadyInUse:   return .emailAlreadyInUse
        case .invalidEmail:        return .invalidEmail
        case .weakPassword:        return .weakPassword
        case .networkError:        return .networkError
        case .wrongPassword:       return .wrongPassword
        case .userNotFound:        return .userNotFound
        case .userDisabled:        return .userDisabled
        case .tooManyRequests:     return .tooManyRequests
        case .requiresRecentLogin: return .requiresRecentLogin
        default:                   return .unknown(error.localizedDescription)
        }
    }
}

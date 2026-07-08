import Foundation

protocol AuthenticationRepositoryProtocol {
    func register(input: RegisterInput) async throws -> User
    func login(email: String, password: String) async throws -> User
    func signInWithGoogle() async throws -> User
    func continueAsGuest() async
    func signOut() async
    func sendEmailVerification() async throws
    func checkEmailVerified() async -> Bool
    func sendPasswordReset(email: String) async throws
}

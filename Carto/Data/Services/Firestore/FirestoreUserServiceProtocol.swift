import Foundation

protocol FirestoreUserServiceProtocol {
    func saveUser(dto: UserFirestoreDTO) async throws
    func fetchUser(uid: String) async throws -> UserFirestoreDTO
    func isEmailRegistered(_ email: String) async throws -> Bool
    func updateShopifyData(uid: String, shopifyCustomerId: String, customerAccessToken: String) async throws
    func deleteUser(uid: String) async throws
}

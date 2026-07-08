import Foundation

struct FirebaseUserMapper {

    static func toDomain(
        authResult: FirebaseAuthUser,
        firestoreData: UserFirestoreDTO
    ) -> User {
        User(
            uid: authResult.uid,
            firstName: firestoreData.firstName,
            lastName: firestoreData.lastName,
            email: authResult.email ?? firestoreData.email,
            isEmailVerified: authResult.isEmailVerified,
            shopifyCustomerId: firestoreData.shopifyCustomerId,
            customerAccessToken: firestoreData.customerAccessToken
        )
    }
}

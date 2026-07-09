import UIKit
import PaymobSDK

enum PaymobCheckoutResult {
    case success(transactionId: String?)
    case failure(String)
    case cancelled
}

@MainActor
protocol PaymobCheckoutPresenting {
    func presentCheckout(
        clientSecret: String,
        publicKey: String,
        from presenter: UIViewController
    ) async -> PaymobCheckoutResult
}

@MainActor
final class PaymobSDKAdapter: NSObject {

    private var continuation: CheckedContinuation<PaymobCheckoutResult, Never>?
    private var sdk: PaymobSDK?
    
}

extension PaymobSDKAdapter: PaymobCheckoutPresenting {

    func presentCheckout(
        clientSecret: String,
        publicKey: String,
        from presenter: UIViewController
    ) async -> PaymobCheckoutResult {

        guard continuation == nil else {
            return .failure("Another payment is already in progress.")
        }

        return await withCheckedContinuation { continuation in

            self.continuation = continuation

            let sdk = PaymobSDK()
            sdk.delegate = self
            let theme = sdk.paymobSDKCustomization

            theme.appName = "Carto"
            theme.appIcon = UIImage(named: "app_logo")
            theme.buttonBackgroundColor = UIColor(named: "PrimaryColor") ?? .systemBlue
            theme.buttonTextColor = .white
            theme.isKeyboardHandlingEnabled = true
            theme.showSaveCard = false
            theme.showTransactionResult = false

            self.sdk = sdk
            
            do {
                try sdk.presentPayVC(
                    VC: presenter,
                    PublicKey: publicKey,
                    ClientSecret: clientSecret
                )

            } catch {
                finish(.failure(error.localizedDescription))
            }
        }
    }
}

private extension PaymobSDKAdapter {

    func finish(_ result: PaymobCheckoutResult) {

        guard let continuation else { return }

        self.continuation = nil
        self.sdk = nil

        continuation.resume(returning: result)
    }
}

// MARK: - PaymobSDKDelegate

extension PaymobSDKAdapter: PaymobSDKDelegate {

    func transactionAccepted(transactionDetails: [String : Any]) {
        let id = transactionDetails["id"].map(String.init(describing:))
        finish(.success(transactionId: id))
    }

    func transactionRejected(message: String) {
        guard !message.isEmpty else {
            finish(.cancelled)
            return
        }
        
        finish(.failure(message))
    }

    func transactionPending() {

    }
}

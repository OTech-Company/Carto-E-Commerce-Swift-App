import Foundation

enum AppConstants {
    static let appName           = "Carto"
    static let defaultLanguage   = "en"
    static let defaultCurrency   = "USD"
    static let defaultPageSize   = 20

    enum Keys {
        static let userAccessToken  = "user_access_token"
        static let isLoggedIn       = "is_logged_in"
        static let selectedLanguage = "selected_language"
        static let selectedTheme    = "selected_theme"
        static let cartID           = "cart_id"
    }

    enum Storage {
        static let modelName = "Carto"
    }
}

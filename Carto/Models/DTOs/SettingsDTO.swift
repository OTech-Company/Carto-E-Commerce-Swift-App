
// SettingsDTO — user preferences from Shopify account
struct SettingsDTO: Codable {
    let language: String
    let currency: String
    let notificationsEnabled: Bool
}


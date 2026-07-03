//
//  AppEnvironment.swift
//  Carto
//
//  Created by Osama Hosam on 03/07/2026.
//

import Foundation

enum AppEnvironment {
    
    // Existing Groq key...
    static let groqApiKey = getString(for: "GroqAPIKey")
    
    // Shopify Injected Properties
    static let shopDomain = getString(for: "ShopifyShopDomain")
    static let apiVersion = getString(for: "ShopifyApiVersion")
    static let shopifyAccessToken = getString(for: "ShopifyAccessToken")
    static let storefrontAccessToken = getString(for: "ShopifyStorefrontToken")
    static let storePassword = getString(for: "ShopifyStorePassword")
    static let apiKey = getString(for: "ShopifyApiKey")
    static let apiSecretKey = getString(for: "ShopifyApiSecretKey")
    
    private static func getString(for key: String) -> String {
        guard let value = Bundle.main.infoDictionary?[key] as? String else {
            fatalError("🚨 Key '\(key)' is missing from your target Info.plist configuration.")
        }
        if value.hasPrefix("$(") && value.hasSuffix(")") {
            fatalError("🚨 The variable matching '\(key)' was not resolved by your xcconfig setup.")
        }
        return value
    }
}

//
//  PaymobAPIClient.swift
//  Carto
//
//  Created by Mohamed Ayman on 05/07/2026.
//

import Foundation

enum PaymobError: LocalizedError {
    case requestFailed(Int)
    case invalidConfiguration

    var errorDescription: String? {
        switch self {
        case .requestFailed(let code): return "Paymob request failed (\(code))."
        case .invalidConfiguration: return "Missing Paymob public/secret key or integration ID configuration."
        }
    }
}

enum PaymobConfiguration {
    static var secretKey: String = NetworkConstants.paymobApiSecretKey
    
    static var publicKey: String = NetworkConstants.paymobApiPublicKey

    static var integrationIds: [Int] = [NetworkConstants.paymobApiIntegrationId]
}

final class PaymobAPIClient {

    static let shared = PaymobAPIClient()

    private let session: URLSession
    private let baseURL = URL(string: "https://accept.paymob.com")!

    private init(session: URLSession = .shared) {
        self.session = session
    }

    func post<Body: Encodable, Response: Decodable>(
        _ path: String,
        body: Body,
        headers: [String: String] = [:]
    ) async throws -> Response {
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await session.data(for: request)

        if let http = response as? HTTPURLResponse {
            print("STATUS:", http.statusCode)
        }

        print("URL:", request.url?.absoluteString ?? "")
        print("HEADERS:", request.allHTTPHeaderFields ?? [:])
        print("BODY:", String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "")
        print("RESPONSE:", String(data: data, encoding: .utf8) ?? "")

        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw PaymobError.requestFailed((response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        return try JSONDecoder().decode(Response.self, from: data)
    }
}

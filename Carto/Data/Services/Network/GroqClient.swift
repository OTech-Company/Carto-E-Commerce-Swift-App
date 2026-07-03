//
//  GroqClient.swift
//  Carto
//
//  Created by Osama Hosam on 03/07/2026.
//



import Foundation

class GroqClient {
    private let apiKey: String
    private let chatUrl = URL(string: "https://api.groq.com/openai/v1/chat/completions")!
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    // --- Native Text Handlers ---
    struct TextMessage: Encodable { let role: String; let content: String }
    struct TextRequestBody: Encodable { let model: String; let messages: [TextMessage]; let temperature: Double }
    
    // --- Native Vision Handlers ---
    struct VisionMessage: Encodable {
        let role: String
        let content: [VisionContent]
    }
    struct VisionContent: Encodable {
        let type: String
        let text: String?
        let image_url: ImageURLContainer?
    }
    struct ImageURLContainer: Encodable { let url: String }
    struct VisionRequestBody: Encodable { let model: String; let messages: [VisionMessage] }
    
    // --- Response Decode Target ---
    struct GroqResponse: Decodable {
        let choices: [Choice]
        struct Choice: Decodable { let message: ResponseMessage }
        struct ResponseMessage: Decodable { let content: String }
    }
    
    // Core function for rapid text processing (Uses GPT-OSS 20B at ~1,000 tokens/sec)
    func processText(messages: [TextMessage], model: String = "openai/gpt-oss-20b") async throws -> String {
        var request = URLRequest(url: chatUrl)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = TextRequestBody(model: model, messages: messages, temperature: 0.5)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "GroqText", code: 400, userInfo: [NSLocalizedDescriptionKey: String(data: data, encoding: .utf8) ?? "Error"])
        }
        return try JSONDecoder().decode(GroqResponse.self, from: data).choices.first?.message.content ?? ""
    }
    
    // Core function for Image parsing (Uses Llama 4 Scout Vision)
    func processImage(prompt: String, base64Image: String) async throws -> String {
        var request = URLRequest(url: chatUrl)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let contents = [
            VisionContent(type: "text", text: prompt, image_url: nil),
            VisionContent(type: "image_url", text: nil, image_url: ImageURLContainer(url: "data:image/jpeg;base64,\(base64Image)"))
        ]
        let body = VisionRequestBody(model: "meta-llama/llama-4-scout-17b-16e-instruct", messages: [VisionMessage(role: "user", content: contents)])
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "GroqVision", code: 400, userInfo: [NSLocalizedDescriptionKey: String(data: data, encoding: .utf8) ?? "Error"])
        }
        return try JSONDecoder().decode(GroqResponse.self, from: data).choices.first?.message.content ?? ""
    }
    
}

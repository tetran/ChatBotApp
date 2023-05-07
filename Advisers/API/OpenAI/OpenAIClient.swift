//
//  OpenAIClient.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/07.
//

import Foundation

class OpenAIClient {
    static let shared = OpenAIClient()
    
    private let communicator = APICommunicator()
    
    private var requestEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
    
    private var responseDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }
    
    private init() {}
    
    func postJson<T: Encodable, U: Decodable>(_ path: String, parameters: T) async -> U? {
        do {
            let requestBody = try requestEncoder.encode(parameters)
            print("Encoded Parameters: \(String(data: requestBody, encoding: .utf8) ?? "Failed")")
            
            let url = makeUrl(path)
            let request = APIRequest(url: url, method: "POST", headers: makeHeader(), body: requestBody)
            print("Request: \(request)")
            
            let response = try await communicator.performRequest(request)
            print("Response: \(response)")
            
            return try responseDecoder.decode(U.self, from: response.body)
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
    
    func chat(_ parameters: ChatRequest) async -> ChatResponse? {
        print("Parameters: \(parameters)")
        return await postJson("/chat/completions", parameters: parameters)
    }
    
    private func makeUrl(_ path: String) -> String {
        return "\(OpenAIConfig.baseUrl)\(OpenAIConfig.apiVersion)\(path)"
    }
    
    private func makeHeader() -> [String: String] {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(OpenAIConfig.apiKey)",
            "OpenAI-Organization": OpenAIConfig.organizationId
        ]
    }
}

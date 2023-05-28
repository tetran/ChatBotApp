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
    
    /// 利用可能なモデル一覧を取得する
    func models() async throws -> ModelsResponse {
        return try await get("/models")
    }
    
    /// chatリクエストを行う
    func chat(_ parameters: ChatRequest) async throws -> ChatResponse {
        return try await postJson("/chat/completions", parameters: parameters)
    }
    
    private func get<U: Decodable>(_ path: String) async throws -> U {
        let request = APIRequest(url: makeUrl(path), method: "GET", headers: makeHeader())
        print("Request: \(request)")
        
        let response = try await communicator.performRequest(request)
        print("Response: \(response)")
        
        return try responseDecoder.decode(U.self, from: response.body)
    }
    
    private func postJson<T: Encodable, U: Decodable>(_ path: String, parameters: T) async throws -> U {
        let requestBody = try requestEncoder.encode(parameters)
        let logPrefix = path.replacingOccurrences(of: "/", with: ".")
        
        APILogger.shared.putLog("Request: \(String(data: requestBody, encoding: .utf8) ?? "No Body")", prefix: logPrefix)
        
        let url = makeUrl(path)
        let request = APIRequest(url: url, method: "POST", headers: makeHeader(), body: requestBody)
        
        let response = try await communicator.performRequest(request)
        APILogger.shared.putLog("Response Status: \(response.statusCode)\nHeaders: \(response.headers)\nBody: \(String(data: response.body, encoding: .utf8) ?? "No Body")", prefix: logPrefix)
        
        if response.statusCode != 200 {
            let errorResponse = try responseDecoder.decode(ErrorResponse.self, from: response.body)
            throw NSError(domain: "Invalid response", code: -1, userInfo: ["Status": response.statusCode, "Error": errorResponse])
        }
        
        return try responseDecoder.decode(U.self, from: response.body)
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

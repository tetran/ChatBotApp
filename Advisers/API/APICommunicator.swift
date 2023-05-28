//
//  APICommunicator.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/07.
//

import Foundation

struct APICommunicator {
    func performRequest(_ request: APIRequest) async throws -> APIResponse {
        guard let url = URL(string: request.url) else {
            throw NSError(domain: "Invalid URL", code: -1, userInfo: nil)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method
        urlRequest.httpBody = request.body
        urlRequest.timeoutInterval = Double(Config.API.timeout)
        
        if let headers = request.headers {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "Invalid response", code: -1, userInfo: nil)
        }
        
        let responseHeaders = Dictionary(uniqueKeysWithValues: httpResponse.allHeaderFields.map { key, value in
            (String(describing: key), String(describing: value))
        })
        
        return APIResponse(statusCode: httpResponse.statusCode, headers: responseHeaders, body: data)
    }
}

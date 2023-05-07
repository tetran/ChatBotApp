//
//  ChatRequest.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/07.
//

import Foundation

struct ChatRequest: Codable {
    
    let model: String
    
    let messages: [ChatMessage]
 
    let temperature: Double?
    
    let topP: Double?
    
    let n: Int?
    
    let stop: [String]?
    
    let maxTokens: Int?
    
    init(messages: [ChatMessage], model: String = "gpt-3.5-turbo", temperature: Double? = 0.7, topP: Double? = 1, n: Int? = 1, stop: [String]? = nil, maxTokens: Int? = nil) {
        self.model = model
        self.messages = messages
        self.temperature = temperature
        self.topP = topP
        self.n = n
        self.stop = stop
        self.maxTokens = maxTokens
    }
}

//
//  ChatResponse.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/07.
//

import Foundation

struct ChatResponse: Codable {
    
    let id: String
    
    let object: String
    
    let created: Date
    
    let choices: [Choice]

    let usage: Usage
}


extension ChatResponse {
    struct Choice: Codable {
        
        let index: Int
        
        let message: ChatMessage
        
        let finishReason: FinishReason?
    }
}

extension ChatResponse {
    struct Usage: Codable {
        
        let promptTokens: Int
        
        let completionTokens: Int
        
        let totalTokens: Int
    }
}

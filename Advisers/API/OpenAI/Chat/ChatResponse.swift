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
    
}


extension ChatResponse {
    struct Choice: Codable {
        let index: Int
        
        let message: ChatMessage
        
        let finishReason: FinishReason?
    }
}

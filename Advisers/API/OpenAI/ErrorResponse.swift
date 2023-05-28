//
//  ErrorResponse.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/28.
//

import Foundation

struct ErrorResponse: Codable {
    
    let error: OpenAIError
    
}

extension ErrorResponse {
    
    struct OpenAIError: Codable {
        
        let message: String
        
        let type: String
    }
    
}

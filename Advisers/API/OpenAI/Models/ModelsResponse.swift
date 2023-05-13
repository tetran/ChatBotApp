//
//  ModelsResponse.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/13.
//

import Foundation

struct ModelsResponse: Codable {
    
    let data: [OpenAIModel]
    
    let object: String
    
}

//
//  OpenAIConfig.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/06.
//

import Foundation

struct OpenAIConfig {
    
    static let baseUrl = "https://api.openai.com/"
    
    static let apiVersion = "v1"
    
    static var apiKey: String {
        UserDataManager.shared.apiKey
    }
    
    static var organizationId: String {
        UserDataManager.shared.organizationId
    }
}

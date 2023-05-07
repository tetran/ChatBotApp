//
//  Usage.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/07.
//

import Foundation

struct Usage: Codable {
    
    let promptTokens: Int
    
    let completionTokens: Int?
    
    let totalTokens: Int
}

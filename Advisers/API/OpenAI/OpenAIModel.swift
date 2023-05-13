//
//  Model.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/13.
//

import Foundation

struct OpenAIModel: Codable, Identifiable {
    
    let id: String
 
    let object: String
    
    let ownedBy: String
}

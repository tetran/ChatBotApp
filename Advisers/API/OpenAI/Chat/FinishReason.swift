//
//  FinishReason.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/07.
//

import Foundation

enum FinishReason: String, Codable {
    /// API returned complete model output
    case stop
    
    /// Incomplete model output due to max_tokens parameter or token limit
    case length
    
    /// Omitted content due to a flag from our content filters
    case contentFilter = "content_filter"
}

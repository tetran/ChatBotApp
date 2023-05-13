//
//  Message.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/04.
//

import Foundation

struct Message: Identifiable {
    
    var id: UUID
    
    var text: String
    
    var createdAt: Date
    
    var postedBy: String
    
    var destination: String?
    
    var fullMessage: String {
        if let destination = destination {
            return "@\(destination)\n\(text)"
        } else {
            return text
        }
    }
}

extension Message: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

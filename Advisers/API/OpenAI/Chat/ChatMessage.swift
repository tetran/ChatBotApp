//
//  ChatMessage.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/07.
//

import Foundation

enum ChatMessage: Codable {
    
    case system(content: String)
    
    case user(content: String)
    
    case assistant(content: String)
}

extension ChatMessage {
    private enum CodingKeys: String, CodingKey {
        case role
        case content
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let role = try container.decode(String.self, forKey: .role)
        let content = try container.decode(String.self, forKey: .content)
        switch role {
        case "system":
            self = .system(content: content)
        case "user":
            self = .user(content: content)
        case "assistant":
            self = .assistant(content: content)
        default:
            throw DecodingError.dataCorruptedError(forKey: .role, in: container, debugDescription: "Invalid type")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .system(let content):
            try container.encode("system", forKey: .role)
            try container.encode(content, forKey: .content)
        case .user(let content):
            try container.encode("user", forKey: .role)
            try container.encode(content, forKey: .content)
        case .assistant(let content):
            try container.encode("assistant", forKey: .role)
            try container.encode(content, forKey: .content)
        }
    }
    
    var content: String {
        switch self {
        case .system(let content), .user(let content), .assistant(let content):
            return content
        }
    }
}

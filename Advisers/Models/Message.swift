//
//  Message.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/04.
//

import SwiftUI

struct Message: Identifiable {
    
    var id: UUID
    
    var text: String
    
    var postedAt: Date
    
    var postedBy: String
    
    var postedTo: String?
    
    var messageType: MessageType
    
    var senderColor: Color?
    
    var receiverColor: Color?
    
    init(id: UUID, text: String, postedAt: Date, postedBy: String, postedTo: String? = nil, messageType: MessageType, senderColor: NativeColor? = nil, receiverColor: NativeColor? = nil) {
        self.id = id
        self.text = text
        self.postedAt = postedAt
        self.postedBy = postedBy
        self.postedTo = postedTo
        self.messageType = messageType
        if let senderColor = senderColor {
            self.senderColor = Color(senderColor)
        }
        if let receiverColor = receiverColor {
            self.receiverColor = Color(receiverColor)
        }
    }
}

extension Message: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum MessageType {
    case user
    case bot
    case summary
}

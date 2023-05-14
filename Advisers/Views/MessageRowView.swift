//
//  MessageRowView.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/04.
//

import SwiftUI

struct MessageRowView: View {
    var message: Message
    
    @State private var isHovered = false
    
    var senderColor: Color {
        message.senderColor ?? .white
    }
    
    var receiverBgColor: Color {
        (message.receiverColor ?? .white).opacity(0.7)
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack {
                Image(systemName: message.senderType == .user ? "person.crop.square" : "poweroutlet.type.b")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(5)
                    .foregroundColor(senderColor)
                Spacer()
            }
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .bottom) {
                    Text(message.postedBy)
                        .font(.headline)
                    Text(message.postedAt.appFormat())
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                
                if let postedTo = message.postedTo {
                    Text(" @\(postedTo) ")
                        .padding(2)
                        .font(.caption)
                        .background(receiverBgColor)
                        .cornerRadius(2)
                }
                
                Text(message.text)
                    .lineSpacing(4)
                    .textSelection(.enabled)
            }
        }
        .padding(8)
        .background(isHovered ? Style.messageHoverBGColor : Style.roomBGColor)
        .onHover { hover in
            isHovered = hover
        }
    }
}

struct BotMessageRowView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let firstMessage = UserMessage.fetchFirst(in: context)
        MessageRowView(message: firstMessage!.toMessage())
    }
}

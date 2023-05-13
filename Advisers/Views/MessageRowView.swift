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
    
    var body: some View {
        HStack(alignment: .top) {
            VStack {
                Image(systemName: "gear")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(5)
                Spacer()
            }
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .bottom) {
                    Text(message.postedBy)
                        .font(.headline)
                    Text(message.createdAt.appFormat())
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                
                Text(message.fullMessage)
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
        let firstMessage = BotMessage.fetchFirst(in: context)
        MessageRowView(message: firstMessage!.toMessage())
    }
}

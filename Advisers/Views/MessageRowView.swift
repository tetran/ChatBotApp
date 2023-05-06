//
//  MessageRowView.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/04.
//

import SwiftUI

struct MessageRowView: View {
    var message: Message
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(message.postedBy)
                    .bold()
                Text(message.createdAt.appFormat())
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            Text(message.text)
        }
        .padding(.vertical, 4)
    }
}

struct BotMessageRowView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let firstMessage = BotMessage.fetchFirst(in: context)
        MessageRowView(message: firstMessage!.toMessage())
    }
}

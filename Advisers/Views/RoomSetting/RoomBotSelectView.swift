//
//  RoomBotSelectView.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/06.
//

import SwiftUI

struct RoomBotSelectView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    let room: Room
    @Binding var newBotId: UUID?
    @Binding var bots: [Bot]
    
    var selectableBots: [Bot] {
        Bot.fetchAll(in: viewContext).filter { bot in
            !room.fetchRelatedBots().contains(bot)
        }
    }
    
    var body: some View {
        List {
            ForEach(selectableBots) { bot in
                Button {
                    let roomBot = RoomBot(context: viewContext)
                    roomBot.room = room
                    roomBot.bot = bot
                    roomBot.attendedAt = Date()
                    
                    try! viewContext.save()
                    
                    bots.append(bot)
                    newBotId = bot.id
                    dismiss()
                } label: {
                    Text(bot.name)
                }
            }
        }
    }
}

struct RoomBotSelectView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let firstRoom = Room.fetchFirst(in: context)
        RoomBotSelectView(room: firstRoom!, newBotId: .constant(nil), bots: .constant([]))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

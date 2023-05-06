//
//  RoomBotSettingView.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/04.
//

import SwiftUI

struct RoomBotSettingView: View {
    @Environment(\.managedObjectContext) private var viewContext

    let room: Room
    
    @State private var bots: [Bot] = []
    @State private var showAddBot = false
    @State private var newBotId: UUID?

    var body: some View {
        List {
            Button {
                showAddBot = true
            } label: {
                Label("Add Bot", systemImage: "plus")
            }
            .sheet(isPresented: $showAddBot) {
                RoomBotSelectView(room: room, newBotId: $newBotId, bots: $bots)
            }

            ForEach(bots) { bot in
                HStack {
                    Text(bot.name)
                    
                    Spacer()
                    
                    Button {
                        if let botIndex = bots.firstIndex(of: bot) {
                            bots.remove(at: botIndex)
                            room.deleteRelatedBot(bot, context: viewContext)
                        }
                    } label: {
                        Label("外す", systemImage: "xmark")
                    }
                }
                .padding()
                .background(bot.id == newBotId ? Color.teal : Color.clear)
                .cornerRadius(4)
            }
        }
        .onChange(of: newBotId) { newBotId in
            if newBotId != nil {
                disableHightlight()
            }
        }
        .onAppear {
            bots = room.fetchRelatedBots()
        }
    }

    private func disableHightlight() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 1.0)) {
                self.newBotId = nil
            }
        }
    }
}

struct RoomBotSettingView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let firstRoom = Room.fetchFirst(in: context)
        RoomBotSettingView(room: firstRoom!)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

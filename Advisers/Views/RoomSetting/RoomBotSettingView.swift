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
    
    @State private var showAddBot = false
    @State private var newBotId: UUID?
    @State private var deletingBot: Bot?
    @State private var showDeletingAlert = false
    
    @Binding var assignedBots: [Bot]
    
    private let numAssignableBots = 4

    var body: some View {
        List {
            Button {
                showAddBot = true
            } label: {
                Label("Bot追加", systemImage: "plus")
                    .padding(4)
            }
            .sheet(isPresented: $showAddBot) {
                RoomBotSelectView(room: room, newBotId: $newBotId, assignedBots: $assignedBots)
                    .frame(width: 300, height: 400)
            }
            .buttonStyle(AppButtonStyle(
                foregroundColor: .white,
                pressedForegroundColor: .white.opacity(0.6),
                backgroundColor: .accentColor,
                pressedBackgroundColor: .accentColor.opacity(0.6)
            ))
            .frame(maxWidth: .infinity)
            .disabled(assignedBots.count >= numAssignableBots)

            ForEach(assignedBots) { bot in
                HStack {
                    Text(bot.name)
                    
                    Spacer()
                    
                    Button {
                        removeBotFromRoom(bot: bot)
//                        deletingBot = bot
//                        showDeletingAlert.toggle()
                    } label: {
                        Label("外す", systemImage: "xmark")
                            .padding(4)
                    }
                    .buttonStyle(AppButtonStyle(
                        foregroundColor: .red,
                        pressedForegroundColor: .red.opacity(0.6),
                        backgroundColor: .clear,
                        pressedBackgroundColor: .clear
                    ))
                }
                .padding(8)
                .background(bot.id == newBotId ? Color(bot.themeColor) : Color(bot.themeColor).opacity(0.1))
                .cornerRadius(4)
                // 「外す」を押してダイアログが閉じられた後、なぜかもう一度表示される問題があるため保留
//                .alert("OK?", isPresented: $showDeletingAlert, presenting: deletingBot, actions: { bot in
//                    Button("外す", role: .destructive) {
//                        removeBotFromRoom(bot: bot)
//                    }
//                    Button("そのまま", role: .cancel) {
//                        print("canceled")
//                    }
//                })
            }
        }
        .onChange(of: newBotId) { newBotId in
            if newBotId != nil {
                disableHightlight()
            }
        }
    }

    private func disableHightlight() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.newBotId = nil
            }
        }
    }
    
    private func removeBotFromRoom(bot: Bot) {
        if let botIndex = assignedBots.firstIndex(of: bot) {
            assignedBots.remove(at: botIndex)
            room.deleteRelatedBot(bot, context: viewContext)
            print("deleted \(bot.name)")
        }
    }
}

struct RoomBotSettingView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let firstRoom = Room.fetchFirst(in: context)
        RoomBotSettingView(room: firstRoom!, assignedBots: .constant([]))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

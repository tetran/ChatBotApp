//
//  BotSettingView.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/04.
//

import SwiftUI

struct BotSettingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Bot.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Bot.name, ascending: true)],
        animation: .default)
    private var bots: FetchedResults<Bot>
    
    @State private var selectedBot: Bot?
    @State private var showNewBot = false
    @State private var newBotId: UUID?
    
    var body: some View {
        NavigationView {
            VStack {
                List(selection: $selectedBot) {
                    ForEach(bots) { bot in
                        NavigationLink {
                            EditBotView(bot: bot)
                        } label: {
                            Text(bot.name)
                                .font(.title2)
                                .padding(8)
                        }
                        .tag(bot)
                    }
                }
                .frame(minWidth: 300)
                .navigationTitle("Bot")
                .onChange(of: newBotId) { botId in
                    if let botId = botId {
                        selectedBot = bots.first(where: { $0.id == botId })
                        newBotId = nil
                    }
                }
                .onAppear {
                    if let botId = newBotId {
                        selectedBot = bots.first(where: { $0.id == botId })
                        newBotId = nil
                    }
                }
                
                
                Button {
                    showNewBot = true
                } label: {
                    Label("Botを追加する", systemImage: "plus")
                        .padding()
                }
                .padding()
                .buttonStyle(.plain)
                .sheet(isPresented: $showNewBot) {
                    NewBotView() { newBot in
                        // 作成画面を閉じた時に、新しいボットにフォーカスさせる
                        newBotId = newBot.id
                    }
                        .frame(minWidth: 400, minHeight: 200)
                }
            }
        }
        .onAppear {
            selectedBot = bots.first
        }
    }
}

struct BotSettingView_Previews: PreviewProvider {
    static var previews: some View {
        BotSettingView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .frame(width: 600, height: 300)
    }
}

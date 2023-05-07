//
//  RoomView.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/04.
//

import SwiftUI

struct RoomView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var messages: [Message] = []
    @State private var assignedBots: [Bot] = []

    @State private var targetBot: Bot?
    @State private var newText: String = ""

    @State private var showRoomSetting = false

    let room: Room

    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                Text(room.name)
                    .font(.title)
                    .padding()
                Spacer()
                Button {
                    showRoomSetting = true
                } label: {
                    Label("Setting", systemImage: "gear")
                }
                .sheet(isPresented: $showRoomSetting) {
                    RoomSettingView(room: room)
                        .frame(minWidth: 400, minHeight: 400)
                }
                .padding()
            }

            Divider()

            ScrollView {
                ForEach(messages) { message in
                    MessageRowView(message: message)
                }
            }
            .padding(8)

            Divider()

            Text(targetBot?.name ?? "No selection")
            
            Picker("Botを選択", selection: $targetBot) {
                ForEach(assignedBots) { bot in
                    // targetBot がオプショナルなので、タグもオプショナルにする
                    Text(bot.name).tag(Optional(bot))
                }
            }
            .pickerStyle(.segmented)
            .padding()

            ZStack {
                TextEditor(text: $newText)
                    .font(.system(size: 20))
                    .frame(maxWidth : .infinity, minHeight: 60, maxHeight: .infinity)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            let userMessage = UserMessage(context: viewContext)
                            userMessage.id = UUID()
                            userMessage.text = newText
                            userMessage.room = room
                            userMessage.createdAt = Date()
                            room.addToUserMessages(userMessage)
                            try! viewContext.save()

                            self.messages.append(userMessage.toMessage())

                            newText = ""

                            guard let bot = targetBot else {
                                return
                            }

                            let text = userMessage.text
                            Task {
                                var messages: [ChatMessage] = []
                                messages.append(.system(content: "The following is a conversation with an AI assistant. The assistant is helpful, creative, clever, and very friendly. The AI assistant's name is \(bot.name)."))
                                if let preText = bot.preText {
                                    messages.append(.system(content: preText))
                                }
                                for example in bot.exampleMessagesArray {
                                    messages.append(.user(content: example.userMessage))
                                    messages.append(.assistant(content: example.assistantMessage))
                                }
                                messages.append(.system(content: "Now, we start a new conversation."))
                                
                                messages.append(.user(content: text))
                                
                                print("Messages: \(messages)")
                                
                                let params = ChatRequest(messages: messages)
                                let response = await OpenAIClient.shared.chat(params)
                                print(response ?? "None")

                                if let message = response?.choices.first?.message {
                                    let botMessage = BotMessage(context: viewContext)
                                    botMessage.id = UUID()
                                    botMessage.bot = bot
                                    botMessage.text = message.content
                                    botMessage.room = room
                                    botMessage.createdAt = Date()

                                    try! viewContext.save()

                                    self.messages.append(botMessage.toMessage())
                                }
                            }
                        } label: {
                            Label("送信", systemImage: "paperplane.fill")
                        }
                        .padding()
                        .disabled(targetBot == nil || newText.isEmpty)
                    }
                }
            }
        }
        .onAppear {
            self.messages = room.allMessages()
            self.assignedBots = room.fetchRelatedBots()
        }
    }
}

struct RoomView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let firstRoom = Room.fetchFirst(in: context)

        RoomView(room: firstRoom!)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

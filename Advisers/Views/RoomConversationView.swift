//
//  RoomConversationView.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/07.
//

import SwiftUI

struct RoomConversationView: View {
    @AppStorage(UserDataManager.Keys.model.rawValue) private var selectedModel: String = "gpt-3.5-turbo"
    @Environment(\.managedObjectContext) private var viewContext

    @State private var targetBot: Bot?

    @Binding var newText: String
    @Binding var newMessageAdded: Bool
    @Binding var messages: [Message]
    @Binding var editorHeight: CGFloat

    let room: Room
    let assignedBots: [Bot]

    var body: some View {
        ZStack {
            TextEditor(text: $newText)
                .font(.system(size: 16))
                .lineSpacing(6)
                .autocorrectionDisabled()
                .padding(.top, 48)
                .padding(.horizontal)
                .onChange(of: newText) { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        editorHeight = calcEditorHeight()
                    }
                }
                .onAppear {
                    editorHeight = calcEditorHeight()
                }

            VStack {
                Picker("", selection: $targetBot) {
                    ForEach(assignedBots) { bot in
                        // targetBot がオプショナルなので、タグもオプショナルにする
                        Text("@\(bot.name)")
                            .font(.title2)
                            .tag(Optional(bot))
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                Spacer()
            }


            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        let userMessage = UserMessage.create(in: viewContext, text: newText, room: room, destBot: targetBot).toMessage()
                        messages.append(userMessage)

                        newText = ""
                        newMessageAdded = true

                        guard let bot = targetBot else {
                            return
                        }

                        Task {
                            let messages = MessageBuilder.buildUserMessages(newMessage: userMessage, to: bot, histories: self.messages)
                            print("================ Messages:")
                            messages.forEach { msg in
                                print("\(msg)")
                            }

                            let params = ChatRequest(messages: messages, model: selectedModel)
                            let response = await OpenAIClient.shared.chat(params)
                            print(response ?? "None")

                            if let message = response?.choices.first?.message {
                                let botMessage = BotMessage.create(in: viewContext, text: message.content, bot: bot, room: room)
                                self.messages.append(botMessage.toMessage())
                                newMessageAdded = true
                            }
                        }
                    } label: {
                        Label("送信", systemImage: "paperplane.fill")
                    }
                    .padding()
                    .buttonStyle(.plain)
                    .font(.title2)
                    .disabled(targetBot == nil || newText.isEmpty)
                }
            }
        }
        .background(Color(NSColor.textBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 2)
        )
        .padding(EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 12))
    }

    private func calcEditorHeight() -> CGFloat {
        let newLineCount = newText.filter { $0 == "\n" }.count
        return min(CGFloat(newLineCount) * 22 + 150, 480)
    }
}

struct RoomConversationView_Previews: PreviewProvider {
    static var previews: some View {
        RoomConversationView(newText: .constant(""), newMessageAdded: .constant(false), messages: .constant([]), editorHeight: .constant(100), room: Room(), assignedBots: [])
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

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

    var canSend: Bool {
        targetBot != nil && !newText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        ZStack {
            CustomTextEditor(text: $newText) {
                guard canSend, let bot = targetBot else { return }

                let userMessage = createNewMessage()
                Task {
                    await sendNewMessage(userMessage: userMessage, to: bot)
                }
            }
            .lineSpacing(6)
            .padding(.top, 48)
            .padding(.leading, 16)
            .padding(.trailing, 92)
            .onChange(of: newText) { _ in
                withAnimation(.easeInOut(duration: 0.1)) {
                    editorHeight = calcEditorHeight()
                }
            }
            .onAppear {
                editorHeight = calcEditorHeight()
            }

            // Bot選択
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


            // 送信ボタン
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        guard let bot = targetBot else {
                            return
                        }

                        let userMessage = createNewMessage()
                        Task {
                            await sendNewMessage(userMessage: userMessage, to: bot)
                        }
                    } label: {
                        Label("送信", systemImage: "paperplane.fill")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                    .padding(8)
                    .buttonStyle(.plain)
                    .font(.title2)
                    .disabled(!canSend)
                    .background(Color.accentColor.opacity(canSend ? 1 : 0.8))
                    .cornerRadius(4)
                }
            }
            .padding(8)
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

    private func createNewMessage() -> Message {
        let userMessage = UserMessage.create(in: viewContext, text: newText, room: room, destBot: targetBot).toMessage()
        messages.append(userMessage)

        newText = ""
        newMessageAdded = true

        return userMessage
    }

    private func sendNewMessage(userMessage: Message, to bot: Bot) async {
        let messages = MessageBuilder.buildUserMessages(newMessage: userMessage, to: bot, histories: self.messages)
        print("================ Messages:")
        messages.forEach { msg in
            print("\(msg)")
        }

        let params = ChatRequest(messages: messages, model: selectedModel)
        let response = await OpenAIClient.shared.chat(params)

        print("================ Response:")
        print(response ?? "None")

        if let message = response?.choices.first?.message {
            let botMessage = BotMessage.create(in: viewContext, text: message.content, bot: bot, room: room)
            self.messages.append(botMessage.toMessage())
            newMessageAdded = true
            SoundPlayer.shared.playRingtone()
        }
    }
}

struct RoomConversationView_Previews: PreviewProvider {
    static var previews: some View {
        RoomConversationView(newText: .constant(""), newMessageAdded: .constant(false), messages: .constant([]), editorHeight: .constant(100), room: Room(), assignedBots: [])
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

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
    @EnvironmentObject var appState: AppState

    @State private var targetBot: Bot?
    @State private var newText: String = ""
    
    @Binding var newMessageAdded: Bool
    @Binding var messages: [Message]
    @Binding var editorHeight: CGFloat
    @Binding var alertMessage: String
    @Binding var roomsWithUnreadMessages: [Room]

    let room: Room
    let assignedBots: [Bot]

    var canSend: Bool {
        targetBot != nil && !newText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !appState.summarizing
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
            .padding(.top, 40)
            .padding(.leading, 12)
            .padding(.trailing, 40)
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
                HStack {
                    ForEach(assignedBots) { bot in
                        Button("@\(bot.name)") {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                targetBot = bot
                            }
                        }
                        .buttonStyle(AppButtonStyle(
                            foregroundColor: .black,
                            pressedForegroundColor: .black,
                            backgroundColor: Color(bot.themeColor),
                            pressedBackgroundColor: Color(bot.themeColor)
                        ))
                        .opacity(targetBot == bot ? 1.0 : 0.4)
                    }
                    Spacer()
                }
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 8))
                
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
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                    }
                    .padding(8)
                    .buttonStyle(.plain)
                    .font(.title2)
                    .disabled(!canSend)
                    .background(Color.accentColor.opacity(canSend ? 1 : 0.5))
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
        .onChange(of: assignedBots) { assignedBots in
            if assignedBots.count == 1 {
                targetBot = assignedBots.first
            }
        }
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
        do {
            let response = try await OpenAIClient.shared.chat(params)
            print("================ Response:\n\(response)")

            if let message = response.choices.first?.message {
                let botMessage = BotMessage.create(in: viewContext, text: message.content, bot: bot, room: room)
                self.messages.append(botMessage.toMessage())
                newMessageAdded = true
                if !roomsWithUnreadMessages.contains(room) {
                    roomsWithUnreadMessages.append(room)
                }
                SoundPlayer.shared.playRingtone()
            }
        } catch {
            alertMessage = error.localizedDescription
        }
    }
}

struct RoomConversationView_Previews: PreviewProvider {
    static var previews: some View {
        RoomConversationView(
            newMessageAdded: .constant(false),
            messages: .constant([]),
            editorHeight: .constant(100),
            alertMessage: .constant(""),
            roomsWithUnreadMessages: .constant([]),
            room: Room(),
            assignedBots: []
        )
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(AppState())
    }
}

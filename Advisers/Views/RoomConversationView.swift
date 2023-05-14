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
                            let messages = buildMessages(userMessage: userMessage, to: bot)
                            print("Messages:")
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

    private func buildMessages(userMessage: Message, to bot: Bot) -> [ChatMessage] {
        var messages: [ChatMessage] = []

        let separator = "\n### Question\n"
        let systemMessage = """
        The following is a conversation between the user and AI assistant(s). Every assistant is helpful, creative, clever, and very friendly. You are one of the AI assistants named `\(bot.name)`. \
        The message contains a line beginning with `[{User Name} -> {Another User}]:`, which is the history of the conversation so far and means that the message that follows was addressed to {Another User} by a user named {User Name}, and `\(bot.name)` is you. \
        You are to answer the question after the `\(separator)` at the end of the last message. Please take into account the flow of the conversation when answering the questions.
        """
        messages.append(.system(content: systemMessage))
        if let preText = bot.preText {
            messages.append(.system(content: preText))
        }

        var newMessages: [String] = []
        self.messages.filter { $0 != userMessage }.forEach { msg in
            if msg.postedBy == bot.name, newMessages.count > 0 {
                newMessages[newMessages.count - 1] = replaceMessageToQuestion(newMessages[newMessages.count - 1], separator: separator)
                messages.append(.user(content: newMessages.joined(separator: "\n")))
                newMessages = []
                messages.append(.assistant(content: msg.text))
                return
            }

            switch(msg.senderType) {
            case .bot:
                newMessages.append("[{\(msg.postedBy)} -> {Human}]: \(msg.text)\n")
            case .user:
                newMessages.append("[{Human} -> {\(msg.postedTo ?? "Robot")}]: \(msg.text)\n")
            }
        }
        newMessages.append("\(separator)\(userMessage.text)")

        messages.append(.user(content: newMessages.joined(separator: "\n")))

        return messages
    }
    
    private func replaceMessageToQuestion(_ text: String, separator: String) -> String {
        let regex = try! NSRegularExpression(pattern: "\\[\\{Human\\} -> \\{.*?\\}\\]:", options: [])
        let range = NSRange(location: 0, length: text.utf16.count)
        let replacedString = regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: separator)
        print(replacedString)
        return replacedString
    }
}

struct RoomConversationView_Previews: PreviewProvider {
    static var previews: some View {
        RoomConversationView(newText: .constant(""), newMessageAdded: .constant(false), messages: .constant([]), editorHeight: .constant(100), room: Room(), assignedBots: [])
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

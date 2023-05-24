//
//  Chatter.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/20.
//

import Foundation

struct MessageBuilder {
    
    static let separatorOfSummary = "\nSummary of Previous: \"\"\""
    
    static func buildUserMessages(newMessage: Message, to bot: Bot, histories: [Message]) -> [ChatMessage] {
        let systemMessage = """
        The following is a conversation between a user named`\(UserDataManager.shared.userName)` and AI assistant(s). The assistant is a helpful, creative, clever, and very friendly.
        Continue the conversation below as `\(bot.name)` as if talking to `\(UserDataManager.shared.userName)`. Response should be in markdown format.
        """

        var preTexts: [String] = [systemMessage]
        if let preText = bot.preText {
            preTexts.append(preText)
        }

        return buildMessages(
            preTexts: preTexts,
            histories: histories,
            instruction: "`\(bot.name)` told `\(UserDataManager.shared.userName)`: "
        )
    }

    static func buildSummarizeMessage(histories: [Message]) -> [ChatMessage] {
        let systemMessage = """
        You are an excellent secretary, and very good at summarizing conversations.
        """
        
        let instruction = """
        \nInstruction: \"\"\"
        Summarize the above conversation briefly by topic in three sections respectively: "Title", "Discussion", "Conclusion".
        Response should be in markdown format. All responses should be in Japanese including section names.
        """
        
        return buildMessages(preTexts: [systemMessage], histories: histories, instruction: instruction)
    }

    private static func buildMessages(preTexts: [String], histories: [Message], instruction: String) -> [ChatMessage] {
        var messages: [ChatMessage] = []
        messages.append(contentsOf: preTexts.map { .system(content: $0) })

        let historiesAfterSummary = selectAfterLastSummary(histories: histories)
        
        var newMessages: [String] = []
        if let first = historiesAfterSummary.first, first.messageType == .summary {
            messages.append(.system(content: "Here is a summary of previous conversation. Consider this when responding.\n\(separatorOfSummary)\n\(first.text)"))
            newMessages.append(contentsOf: historiesToJson(histories: Array(historiesAfterSummary[1...])))
        } else {
            newMessages.append(contentsOf: historiesToJson(histories: historiesAfterSummary))
        }
        newMessages.append(instruction)

        messages.append(.user(content: newMessages.joined(separator: "\n")))
        return messages
    }

    private static func historiesToJson(histories: [Message]) -> [String] {
        return histories.compactMap { msg in
            switch(msg.messageType) {
            case .bot:
                return "`\(msg.postedBy)` told `\(UserDataManager.shared.userName)`: \(msg.text)"
            case .user:
                return "`\(UserDataManager.shared.userName)` told `\(msg.postedTo ?? "Robot")`: \(msg.text)"
            default:
                return nil
            }
        }
    }

    private static func selectAfterLastSummary(histories: [Message]) -> [Message] {
        guard let summaryIndex = histories.lastIndex(where: { $0.messageType == .summary }) else {
            return histories
        }

        return Array(histories[summaryIndex...])
    }
}

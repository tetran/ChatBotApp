//
//  Chatter.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/20.
//

import Foundation

struct MessageBuilder {
    
    static let separatorOfSummary = "<< Summary of Previous >>"
    
    static func buildUserMessages(newMessage: Message, to bot: Bot, histories: [Message]) -> [ChatMessage] {
        let systemMessage = """
        The following is a conversation between a human and AI assistant. The assistant is a helpful, creative, clever, and very friendly.
        Continue the conversation below as `\(bot.name)`. When "\(separatorOfSummary)" section given, consider its content.
        Response should be in markdown format.
        """

        var preTexts: [String] = [systemMessage]
        if let preText = bot.preText {
            preTexts.append(preText)
        }

        return buildMessages(
            preTexts: preTexts,
            histories: selectAfterLastSummary(histories: histories),
            instruction: "`\(bot.name)` said to `Human`: "
        )
    }

    static func buildSummarizeMessage(histories: [Message]) -> [ChatMessage] {
        let systemMessage = """
        The following is a conversation between a human and AI assistant(s).
        """
        
        let instruction = """
        << Instruction >>
        Please summarize the above conversation by topic in four sections respectively: "Topic", "Summary of Discussion", "Conclusion" and "Impressions". \
        When "\(separatorOfSummary)" section given, consider its content.
        Response should be in markdown format, with bullet points for "Summary of Discussion" and "Conclusion". All responses should be in Japanese.
        """

        let historiesAfterSummary = selectAfterLastSummary(histories: histories)
        
        return buildMessages(preTexts: [systemMessage], histories: historiesAfterSummary, instruction: instruction)
    }

    private static func buildMessages(preTexts: [String], histories: [Message], instruction: String) -> [ChatMessage] {
        var messages: [ChatMessage] = []
        messages.append(contentsOf: preTexts.map { .system(content: $0) })

        var newMessages: [String] = []
        if let first = histories.first, first.messageType == .summary {
            newMessages.append("\(separatorOfSummary)\n\(first.text)\n\n<< Conversation >>")
            newMessages.append(contentsOf: historiesToJson(histories: Array(histories[1...])))
        } else {
            newMessages.append(contentsOf: historiesToJson(histories: histories))
        }
        newMessages.append(instruction)

        messages.append(.user(content: newMessages.joined(separator: "\n")))
        return messages
    }

    private static func historiesToJson(histories: [Message]) -> [String] {
        return histories.compactMap { msg in
            switch(msg.messageType) {
            case .bot:
                return "`\(msg.postedBy)` said to `Human`: \(msg.text)"
            case .user:
                return "`Human` said to `\(msg.postedTo ?? "Robot")`: \(msg.text)"
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

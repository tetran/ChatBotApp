//
//  Chatter.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/20.
//

import Foundation

struct MessageBuilder {
    
    static let separatorOfSummary = "## Summary of Previous"
    
    static func buildUserMessages(newMessage: Message, to bot: Bot, histories: [Message]) -> [ChatMessage] {
        let separator = "\n### Instruction\n"
        let systemMessage = """
        The following is a conversation between a human and AI assistant(s). You are a helpful, creative, clever, and very friendly AI assistant named `\(bot.name)`. \
        Lines of the form `{"from": "User", "to": "Another User", "body": "message body"}` show the history of the conversation so far. and means that "message body" was addressed to "Another User" by a user named "User". \
        You are to responde the instruction after the `\(separator)` as `\(bot.name)`, with taking into account the flow of the conversation including "\(separatorOfSummary)" section if any. \
        Please return only the content of "body".
        """

        var preTexts: [String] = [systemMessage]
        if let preText = bot.preText {
            preTexts.append(preText)
        }

        return buildMessages(
            preTexts: preTexts,
            histories: selectAfterLastSummary(histories: histories).filter { $0 != newMessage },
            userMessage: "\(separator)\(newMessage.text)"
        )
    }

    static func buildSummarizeMessage(histories: [Message]) -> [ChatMessage] {
        let systemMessage = """
        The following is a conversation between the user and AI assistant(s). \
        Lines of the form `{"from": "User", "to": "Another User", "body": "message body"}` show the history of the conversation so far. and means that "message body" was addressed to "Another User" by a user named "User".
        """
        
        let userMessage = """
        ## Instruction
        Please summarize the above conversation by topic, including the "Topic", "Summary of Discussion", "Conclusion" and "Impressions" respectively, with taking into account "\(separatorOfSummary)" section if any. \
        Response should be in markdown format, with bullet points for "Summary of Discussion" and "Conclusion". All responses should be in Japanese.
        """

        let historiesAfterSummary = selectAfterLastSummary(histories: histories)
        
        return buildMessages(preTexts: [systemMessage], histories: historiesAfterSummary, userMessage: userMessage)
    }

    private static func buildMessages(preTexts: [String], histories: [Message], userMessage: String? = nil) -> [ChatMessage] {
        var messages: [ChatMessage] = []
        messages.append(contentsOf: preTexts.map { .system(content: $0) })

        var newMessages = historiesToJson(histories: histories)
        if let userMessage = userMessage {
            newMessages.append(userMessage)
        }

        messages.append(.user(content: newMessages.joined(separator: "\n")))

        return messages
    }

    private static func historiesToJson(histories: [Message]) -> [String] {
        return histories.compactMap { msg in
            switch(msg.messageType) {
            case .bot:
                return [
                    "from": msg.postedBy,
                    "to": "Human",
                    "body": msg.text
                ].toJSON()
            case .user:
                return [
                    "from": "Human",
                    "to": msg.postedTo ?? "Robot",
                    "body": msg.text
                ].toJSON()
            default:
                return "\(separatorOfSummary)\n\(msg.text)\n\n## Newer Conversation\n"
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

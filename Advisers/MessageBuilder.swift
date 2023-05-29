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
        The following is a conversation between a user named`\(UserDataManager.shared.userName)` and AI assistant(s). `\(bot.name)` is a helpful, creative, clever, and very friendly assistant.
        Continue the conversation below as `\(bot.name)`, as if talking to `\(UserDataManager.shared.userName)`. Responses should be in markdown format.
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
        The assistant an excellent secretary, and very good at summarizing conversations concisely. Follow the instruction.
        """
        
        let instruction = """
        
        Instruction: \"\"\"
        To report to your supervisor, make a brief summary of the above conversation in two sections: "Subject" and "Main Points".
        The summary should be in Japanese and in shorthand.
        \"\"\"
        """
        
        return buildMessages(preTexts: [systemMessage], histories: histories, instruction: instruction)
    }
    
    static func buildTranslationMessage(source: String) -> [ChatMessage] {
        let systemMessage = """
        The assistant is a professional translator. Follow the instruction.
        """
        
        let instruction = """
        
        Instruction: \"\"\"
        Translate the folloing text into Japanese while preserving the format.
        \"\"\"
        
        Text: \"\"\"
        \(source)
        \"\"\"
        """
        
        return [.system(content: systemMessage), .user(content: instruction)]
    }

    private static func buildMessages(preTexts: [String], histories: [Message], instruction: String) -> [ChatMessage] {
        var messages: [ChatMessage] = []
        messages.append(contentsOf: preTexts.map { .system(content: $0) })

        let historiesAfterSummary = selectAfterLastSummary(histories: histories)
        
        var newMessages: [String] = []
        if let first = historiesAfterSummary.first, first.messageType == .summary {
            messages.append(.system(content: "Use the summary of previous conversation below as a source of information.\n\(separatorOfSummary)\n\(first.text)\n\"\"\""))
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

//
//  BotMessage+CoreDataProperties.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/04.
//
//

import Foundation
import CoreData


extension BotMessage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BotMessage> {
        return NSFetchRequest<BotMessage>(entityName: "BotMessage")
    }

    @NSManaged public var id: UUID
    @NSManaged public var createdAt: Date
    @NSManaged public var text: String
    @NSManaged public var room: Room
    @NSManaged public var bot: Bot
    @NSManaged public var readAt: Date?

}

extension BotMessage : Identifiable {
    
    static func fetchFirst(in context: NSManagedObjectContext) -> BotMessage? {
        let request: NSFetchRequest<BotMessage> = BotMessage.fetchRequest()
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(keyPath : \BotMessage.createdAt, ascending:  true)]

        do {
            return try context.fetch(request).first
        } catch {
            print("Error occurred while fetching: \(error)")
            return nil
        }
    }
    
    static func create(in context: NSManagedObjectContext, text: String, bot: Bot, room: Room) -> BotMessage {
        let botMessage = BotMessage(context: context)
        botMessage.id = UUID()
        botMessage.bot = bot
        botMessage.text = text
        botMessage.room = room
        botMessage.createdAt = Date()
        
        try! context.save()
        
        return botMessage
    }
    
    func toMessage() -> Message {
        return Message(id: id, text: text, postedAt: createdAt, postedBy: bot.name, messageType: .bot, senderColor: bot.themeColor)
    }
}

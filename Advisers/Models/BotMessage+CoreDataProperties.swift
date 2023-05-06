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
    
    func toMessage() -> Message {
        return Message(id: id, text: text, createdAt: createdAt, postedBy: bot.name)
    }
}

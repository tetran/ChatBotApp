//
//  UserMessage+CoreDataProperties.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/04.
//
//

import Foundation
import CoreData


extension UserMessage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserMessage> {
        return NSFetchRequest<UserMessage>(entityName: "UserMessage")
    }

    @NSManaged public var id: UUID
    @NSManaged public var text: String
    @NSManaged public var createdAt: Date
    @NSManaged public var room: Room
    @NSManaged public var destBot: Bot?

}

extension UserMessage : Identifiable {
    
    static func fetchFirst(in context: NSManagedObjectContext) -> UserMessage? {
        let request: NSFetchRequest<UserMessage> = UserMessage.fetchRequest()
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(keyPath : \UserMessage.createdAt, ascending:  true)]
        
        do {
            return try context.fetch(request).first
        } catch {
            print("Error occurred while fetching: \(error)")
            return nil
        }
    }
    
    static func create(in context: NSManagedObjectContext, text: String, room: Room, destBot: Bot?) -> UserMessage {
        let userMessage = UserMessage(context: context)
        userMessage.id = UUID()
        userMessage.text = text
        userMessage.room = room
        userMessage.destBot = destBot
        userMessage.createdAt = Date()
        
        try! context.save()
        
        return userMessage
    }
    
    func toMessage() -> Message {
        return Message(id: id, text: text, postedAt: createdAt, postedBy: "You", postedTo: destBot?.name, messageType: .user, receiverColor: destBot?.themeColor)
    }
}

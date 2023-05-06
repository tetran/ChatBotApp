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
    @NSManaged public var room: Room?

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
    
    func toMessage() -> Message {
        return Message(id: id, text: text, createdAt: createdAt, postedBy: "User")
    }
}

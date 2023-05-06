//
//  Bot+CoreDataProperties.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/04.
//
//

import Foundation
import CoreData


extension Bot {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bot> {
        return NSFetchRequest<Bot>(entityName: "Bot")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var preText: String?
    @NSManaged public var icon: Data?
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
    @NSManaged public var exampleMessages: NSSet?
    @NSManaged public var roomBots: NSSet?

    public var exampleMessagesArray: [ExampleMessage] {
        let set = exampleMessages as? Set<ExampleMessage> ?? []
        return set.sorted {
            $0.createdAt < $1.createdAt
        }
    }
}

// MARK: Generated accessors for exampleMessages
extension Bot {

    @objc(addExampleMessagesObject:)
    @NSManaged public func addToExampleMessages(_ value: ExampleMessage)

    @objc(removeExampleMessagesObject:)
    @NSManaged public func removeFromExampleMessages(_ value: ExampleMessage)

    @objc(addExampleMessages:)
    @NSManaged public func addToExampleMessages(_ values: NSSet)

    @objc(removeExampleMessages:)
    @NSManaged public func removeFromExampleMessages(_ values: NSSet)

}

extension Bot : Identifiable {
    static func fetchFirst(in context: NSManagedObjectContext) -> Bot? {
        let request: NSFetchRequest<Bot> = Bot.fetchRequest()
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(keyPath : \Bot.name, ascending:  true)]

        do {
            return try context.fetch(request).first
        } catch {
            print("Error occurred while fetching: \(error)")
            return nil
        }
    }

    static func fetchAll(in context: NSManagedObjectContext) -> [Bot] {
        let request: NSFetchRequest<Bot> = Bot.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath : \Bot.name, ascending:  true)]

        do {
            return try context.fetch(request)
        } catch {
            print("Error occurred while fetching: \(error)")
            return []
        }
    }
}

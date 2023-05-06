//
//  ExampleMessage+CoreDataProperties.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/04.
//
//

import Foundation
import CoreData


extension ExampleMessage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExampleMessage> {
        return NSFetchRequest<ExampleMessage>(entityName: "ExampleMessage")
    }
    

    @NSManaged public var id: UUID
    @NSManaged public var userMessage: String
    @NSManaged public var assistantMessage: String
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
    @NSManaged public var bot: Bot

}

extension ExampleMessage : Identifiable {
    static func fetchFirst(in context: NSManagedObjectContext) -> ExampleMessage? {
        let request: NSFetchRequest<ExampleMessage> = ExampleMessage.fetchRequest()
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(keyPath : \ExampleMessage.createdAt, ascending:  true)]

        do {
            return try context.fetch(request).first
        } catch {
            print("Error occurred while fetching: \(error)")
            return nil
        }
    }
}

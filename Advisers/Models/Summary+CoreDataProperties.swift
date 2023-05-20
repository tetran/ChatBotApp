//
//  Summary+CoreDataProperties.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/14.
//
//

import Foundation
import CoreData


extension Summary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Summary> {
        return NSFetchRequest<Summary>(entityName: "Summary")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var text: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var room: Room?

}

extension Summary : Identifiable {
    static func create(in context: NSManagedObjectContext, text: String, room: Room) -> Summary {
        let summary = Summary(context: context)
        summary.id = UUID()
        summary.text = text
        summary.room = room
        summary.createdAt = Date()
        
        try! context.save()
        
        return summary
    }
    
    func toMessage() -> Message {
        return Message(id: id!, text: text!, postedAt: createdAt!, postedBy: "Summarizer", messageType: .summary)
    }
}

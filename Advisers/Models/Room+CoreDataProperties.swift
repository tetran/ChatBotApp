//
//  Room+CoreDataProperties.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/04.
//
//

import Foundation
import CoreData


extension Room {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Room> {
        return NSFetchRequest<Room>(entityName: "Room")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
    @NSManaged public var botMessages: NSSet?
    @NSManaged public var userMessages: NSSet?
    @NSManaged public var roomBots: NSSet?
    @NSManaged public var summaries: NSSet?

}

extension Room {

    @objc(addBotMessagesObject:)
    @NSManaged public func addToBotMessages(_ value: BotMessage)

    @objc(removeBotMessagesObject:)
    @NSManaged public func removeFromBotMessages(_ value: BotMessage)

    @objc(addBotMessages:)
    @NSManaged public func addToBotMessages(_ values: NSSet)

    @objc(removeBotMessages:)
    @NSManaged public func removeFromBotMessages(_ values: NSSet)

}

extension Room {

    @objc(addUserMessagesObject:)
    @NSManaged public func addToUserMessages(_ value: UserMessage)

    @objc(removeUserMessagesObject:)
    @NSManaged public func removeFromUserMessages(_ value: UserMessage)

    @objc(addUserMessages:)
    @NSManaged public func addToUserMessages(_ values: NSSet)

    @objc(removeUserMessages:)
    @NSManaged public func removeFromUserMessages(_ values: NSSet)

}

extension Room : Identifiable {
    static func fetchFirst(in context: NSManagedObjectContext) -> Room? {
        let request: NSFetchRequest<Room> = Room.fetchRequest()
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(keyPath : \Room.name, ascending:  true)]

        do {
            return try context.fetch(request).first
        } catch {
            print("Error occurred while fetching: \(error)")
            return nil
        }
    }

    func allMessages() -> [Message] {
        let userMessages: [Message] = userMessages?.allObjects.map { ($0 as! UserMessage).toMessage() } ?? []
        let botMessages: [Message] = botMessages?.allObjects.map { ($0 as! BotMessage).toMessage() } ?? []
        return (userMessages + botMessages).sorted {
            $0.postedAt.timeIntervalSince1970 < $1.postedAt.timeIntervalSince1970
        }
    }

    // 関連するBotの一覧を取得するメソッド
    func fetchRelatedBots() -> [Bot] {
        guard let roomBots = self.roomBots as? Set<RoomBot> else {
            return []
        }

        return roomBots.compactMap { $0.bot }
    }

    func deleteRelatedBot(_ bot: Bot, context: NSManagedObjectContext) {
        if let roomBots = self.roomBots as? Set<RoomBot>,
            let roomBot = roomBots.first(where: { $0.bot == bot }) {
            
            context.delete(roomBot)
            try! context.save()
        }
    }
}

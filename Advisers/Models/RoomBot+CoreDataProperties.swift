//
//  RoomBot+CoreDataProperties.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/06.
//
//

import Foundation
import CoreData


extension RoomBot {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RoomBot> {
        return NSFetchRequest<RoomBot>(entityName: "RoomBot")
    }

    @NSManaged public var attendedAt: Date
    @NSManaged public var room: Room
    @NSManaged public var bot: Bot

}

extension RoomBot : Identifiable {

}

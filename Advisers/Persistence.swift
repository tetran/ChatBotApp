//
//  Persistence.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/04.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
    
        let currentTime = Date()
        let fiveMinutesAgo = currentTime.addingTimeInterval(-5 * 60)
        
        let bot = Bot(context: viewContext)
        bot.id = UUID()
        bot.name = "Oh My Bot"
        bot.createdAt = fiveMinutesAgo
        bot.updatedAt = fiveMinutesAgo
        
        for i in 0..<20 {
            let newRoom = Room(context: viewContext)
            newRoom.id = UUID()
            newRoom.name = "おへやNo.\(i + 1)"
            newRoom.createdAt = fiveMinutesAgo
            newRoom.updatedAt = fiveMinutesAgo
            
            let userMessage = UserMessage(context: viewContext)
            userMessage.id = UUID()
            userMessage.room = newRoom
            userMessage.text = "Message from user \(i)\nHi, I am User!"
            userMessage.createdAt = fiveMinutesAgo
            
            let botMessage = BotMessage(context: viewContext)
            botMessage.id = UUID()
            botMessage.bot = bot
            botMessage.room = newRoom
            botMessage.text = "Message from bot \(i)\nHi, I am bot!"
            botMessage.createdAt = Date()
            
            let roomBot = RoomBot(context: viewContext)
            roomBot.bot = bot
            roomBot.room = newRoom
            roomBot.attendedAt = currentTime
        }
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Advisers")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

//
//  DevMenuView.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/07.
//

import SwiftUI

struct DevMenuView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        VStack {
            Button {
                deleteEntity("BotMessage")
                deleteEntity("UserMessage")
                deleteEntity("RoomBot")
                deleteEntity("Room")
            } label: {
                Text("Room・メッセージを全て削除")
            }
        }
    }
    
    func deleteEntity(_ entityName: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try viewContext.execute(batchDeleteRequest)
            try viewContext.save()
        } catch {
            print("Error deleting data from \(entityName): \(error)")
        }
    }
}

struct DevMenuView_Previews: PreviewProvider {
    static var previews: some View {
        DevMenuView()
    }
}

//
//  DevMenuView.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/07.
//

import SwiftUI

struct DevMenuView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var appState: AppState
    
    @State private var showDeletingAlert = false
    
    var body: some View {
        VStack {
            Button {
                if let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    NSWorkspace.shared.open(documentDir)
                }
            } label: {
                Text("APIログを見る")
            }
            Button {
                showDeletingAlert = true
            } label: {
                Text("Room・メッセージを全て削除")
            }
            .alert("本当に消す？", isPresented: $showDeletingAlert, actions: {
                Button("消す！") {
                    deleteEntity("BotMessage")
                    deleteEntity("UserMessage")
                    deleteEntity("RoomBot")
                    deleteEntity("Room")
                }
                Button("やめる") {}
            })
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
            .environmentObject(AppState())
    }
}

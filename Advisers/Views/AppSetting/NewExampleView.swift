//
//  NewExampleView.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/05.
//

import SwiftUI

struct NewExampleView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    let bot: Bot
    @Binding var newExampleId: UUID?
    
    @State private var userMessage = ""
    @State private var assistantMessage = ""
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("New Example")) {
                    TextField("ユーザー", text: $userMessage)
                        .padding()
                    
                    TextField("アシスタント", text: $assistantMessage)
                        .padding()
                }
            }
            .padding(20)
            
            HStack {
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Text("キャンセル")
                }
                
                Button {
                    let newExample = ExampleMessage(context: viewContext)
                    newExample.id = UUID()
                    newExample.bot = bot
                    newExample.userMessage = userMessage
                    newExample.assistantMessage = assistantMessage
                    newExample.createdAt = Date()
                    newExample.updatedAt = Date()
                    bot.addToExampleMessages(newExample)
                    
                    try! viewContext.save()
                    
                    newExampleId = newExample.id
                    
                    dismiss()
                } label: {
                    Text("追加")
                }
                .padding(.leading)
                .disabled(userMessage.isEmpty || assistantMessage.isEmpty)
            }
            .padding()
        }
    }
}

struct NewExampleView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let firstBot = Bot.fetchFirst(in: context)
        NewExampleView(bot: firstBot!, newExampleId: .constant(nil))
    }
}

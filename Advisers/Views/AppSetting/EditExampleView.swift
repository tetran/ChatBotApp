//
//  EditExampleView.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/05.
//

import SwiftUI

struct EditExampleView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    let example: ExampleMessage
    
    @State private var userMessage = ""
    @State private var assistantMessage = ""

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Edit Example")) {
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
                    example.userMessage = userMessage
                    example.assistantMessage = assistantMessage
                    example.updatedAt = Date()
                    
                    try! viewContext.save()
                    
                    dismiss()
                } label: {
                    Text("保存")
                }
                .padding(.leading)
                .disabled(userMessage.isEmpty || assistantMessage.isEmpty)
            }
            .padding()
        }
        .onAppear {
            userMessage = example.userMessage ?? ""
            assistantMessage = example.assistantMessage ?? ""
        }
    }
}

struct EditExampleView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let examples = try! context.fetch(ExampleMessage.fetchRequest()).first!
        EditExampleView(example: examples)
    }
}

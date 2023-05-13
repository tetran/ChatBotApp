//
//  ExampleMessageRowView.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/06.
//

import SwiftUI

struct ExampleMessageRowView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    let example: ExampleMessage
    @State private var userMessage = ""
    @State private var assistantMessage = ""
    @State private var showEditExample = false
    
    @Binding var exampleArray: [ExampleMessage]
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text("User: ")
                    Text("\(userMessage)")
                }
                HStack(alignment: .top) {
                    Text("Assistant: ")
                    Text("\(assistantMessage)")
                }
            }
            
            Spacer()
            
            Button {
                showEditExample = true
            } label: {
                Text("編集")
                    .foregroundColor(.blue)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 4)
            .sheet(isPresented: $showEditExample) {
                EditExampleView(example: example)
                    .frame(minWidth: 400, minHeight: 200)
            }
            
            Button(action: onDelete) {
                Text("削除")
                    .foregroundColor(.red)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 4)
        }
        .onAppear {
            userMessage = example.userMessage ?? ""
            assistantMessage = example.assistantMessage ?? ""
        }
    }
    
    private func onDelete() {
        viewContext.delete(example)
        exampleArray.removeAll { $0 == example }
        try? viewContext.save()
    }
}

struct ExampleMessageRowView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let ex = ExampleMessage.fetchFirst(in: context)!
        ExampleMessageRowView(example: ex, exampleArray: .constant([]))
            .environment(\.managedObjectContext, context)
    }
}

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
    @State var highliteExampleId: UUID?
    
    @State private var showEditExample = false
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text("User: ")
                    Text("\(example.userMessage)")
                }
                HStack(alignment: .top) {
                    Text("Assistant: ")
                    Text("\(example.assistantMessage)")
                }
            }
            
            Spacer()
            
            Button {
                showEditExample = true
            } label: {
                Text("編集")
            }
            .buttonStyle(.plain)
            .padding(.horizontal)
            .sheet(isPresented: $showEditExample) {
                EditExampleView(example: example, editedExampleId: $highliteExampleId)
                    .frame(minWidth: 400, minHeight: 200)
            }
        }
        .background(example.id == highliteExampleId ? Color.teal : Color.clear)
        .onChange(of: highliteExampleId) { highliteExampleId in
            if highliteExampleId != nil {
                disableHightlight()
            }
        }
        .onAppear {
            disableHightlight()
        }
    }
    
    private func disableHightlight() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 1.0)) {
                self.highliteExampleId = nil
            }
        }
    }
}

struct ExampleMessageRowView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let ex = ExampleMessage.fetchFirst(in: context)!
        ExampleMessageRowView(example: ex, highliteExampleId: nil)
    }
}

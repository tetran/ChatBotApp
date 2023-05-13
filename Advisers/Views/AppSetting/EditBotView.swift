//
//  EditBotView.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/05.
//

import SwiftUI

struct EditBotView: View {
    @Environment(\.managedObjectContext) private var viewContext

    let bot: Bot

    @State private var name = ""
    @State private var preText = ""

    @State private var showNewExample = false
    @State private var showEditExample = false

    @State private var highliteExampleId: UUID?

    @FocusState private var isPreTextFocused: Bool

    var body: some View {
        VStack {
            Form {
                TextField("名前", text: $name, onCommit: saveData)
                    .padding()
                    .textFieldStyle(.roundedBorder)

                LabeledContent("Pre Text") {
                    TextEditor(text: $preText)
                        .padding(4)
                        .frame(minHeight: 100)
                        .border(Color.gray, width: 1)
                        .focused($isPreTextFocused)
                        .onSubmit {
                            if !isPreTextFocused {
                                saveData()
                            }
                        }
                        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                            if isPreTextFocused {
                                saveData()
                            }
                        }
                }
                .padding()
            }
        }
        .padding()
        .onAppear {
            name = bot.name
            preText = bot.preText ?? ""
        }
    }

    private func saveData() {
        guard name != bot.name || preText != bot.preText else {
            return
        }

        bot.name = name
        bot.preText = preText
        try! viewContext.save()
    }
}

struct EditBotView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let firstBot = Bot.fetchFirst(in: context)
        EditBotView(bot: firstBot ?? Bot())
            .environment(\.managedObjectContext, context)
    }
}

//
//  NewBotView.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/05.
//

import SwiftUI

struct NewBotView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var botName = ""
    
    @Binding var newBot: Bot?

    var body: some View {
        VStack {
            Form {
                Section(header: Text("New Bot")) {
                    TextField("名前", text: $botName)
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
                    let bot = Bot(context: viewContext)
                    bot.name = botName
                    bot.id = UUID()
                    bot.createdAt = Date()
                    bot.updatedAt = Date()
                    
                    try! viewContext.save()

                    newBot = bot
                    dismiss()
                } label: {
                    Text("Bot作成")
                }
                .padding(.leading)
                .disabled(botName.isEmpty)
            }
            .padding()
        }
    }
}

struct NewBotView_Previews: PreviewProvider {
    static var previews: some View {
        NewBotView(newBot: .constant(nil))
    }
}

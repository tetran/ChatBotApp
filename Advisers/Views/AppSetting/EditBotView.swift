//
//  EditBotView.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/05.
//

import SwiftUI
import Combine

struct EditBotView: View {
    @Environment(\.managedObjectContext) private var viewContext

    let bot: Bot

    @State private var name = ""
    @State private var preText = ""
    @State private var themeColor: Color = .white

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
                    .onReceive(Just(name)) { _ in limitName(30) }
                
            ColorPicker("テーマカラー", selection: $themeColor)
                .onChange(of: themeColor) { newValue in
                    saveColor(newValue)
                }
                .padding()
                
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
            themeColor = Color(bot.themeColor)
        }
    }
    
    func limitName(_ upper: Int) {
        if name.count > upper {
            name = String(name.prefix(upper))
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
    
    private func saveColor(_ color: Color) {
        let nsColor = NSColor(color)
        if let rgba = nsColor.rgbaComponents {
            bot.colorR = rgba.red
            bot.colorG = rgba.green
            bot.colorB = rgba.blue
            bot.colorA = rgba.alpha
            try! viewContext.save()
        }
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

//
//  RoomView.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/04.
//

import SwiftUI

struct RoomView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var newText: String = ""
    @State private var editorHeight: CGFloat = 200
    @State private var showRoomSetting = false
    
    let room: Room
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                Text(room.name).font(.title)
                Spacer()
                Button {
                    showRoomSetting = true
                } label: {
                    Label("Setting", systemImage: "gear")
                }
                .sheet(isPresented: $showRoomSetting) {
                    RoomSettingView(room: room)
                        .frame(minWidth: 400, minHeight: 400)
                }
            }
            Divider()
            ScrollView {
                ForEach(room.allMessages()) { message in
                    MessageRowView(message: message)
                }
            }
            .padding(8)
            Divider()
            
            ZStack {
                TextEditor(text: $newText)
                    .font(.system(size: 20))
                    .frame(maxWidth : .infinity, minHeight: 120, maxHeight: .infinity)
//                    .onChange(of: newText) { value in
//                        let count = value.split(separator: "\n").count
//                        editorHeight = CGFloat(count) * 30 + 200
//                    }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            let userMessage = UserMessage()
                            userMessage.id = UUID()
                            userMessage.text = newText
                            userMessage.room = room
                            userMessage.createdAt = Date()
                            room.addToUserMessages(userMessage)
                            
                            newText = ""
                        }, label: {
                            Label("送信", systemImage: "paperplane.fill")
                        })
                        .padding()
                    }
                }
            }
        }
    }
}

struct RoomView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let firstRoom = Room.fetchFirst(in: context)

        RoomView(room: firstRoom!)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

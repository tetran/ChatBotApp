//
//  RoomView.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/04.
//

import SwiftUI

struct RoomView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var messages: [Message] = []
    @State private var assignedBots: [Bot] = []

    @State private var targetBot: Bot?
    @State private var newText: String = ""

    @State private var showRoomSetting = false
    @State private var newMessageAdded = false
    @State private var editorHeight: CGFloat = 120

    let room: Room
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                Text(room.name)
                    .font(.title)
                    .padding()
                Spacer()
                Button {
                    showRoomSetting = true
                } label: {
                    Label("Setting", systemImage: "gear")
                }
                .sheet(isPresented: $showRoomSetting) {
                    RoomSettingView(room: room, assignedBots: $assignedBots)
                        .frame(minWidth: 400, minHeight: 400)
                }
                .buttonStyle(.plain)
                .padding()
            }

            Divider()
            
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(messages) { message in
                            MessageRowView(message: message)
                                .id(message)
                        }
                        .onAppear {
                            if messages.count > 0 {
                                proxy.scrollTo(messages[messages.count - 1])
                            }
                        }
                        .onChange(of: newMessageAdded) { added in
                            if added {
                                proxy.scrollTo(messages[messages.count - 1])
                                newMessageAdded = false
                            }
                        }
                    }
                }
            }

            RoomConversationView(
                newText: $newText,
                newMessageAdded: $newMessageAdded,
                messages: $messages,
                editorHeight: $editorHeight,
                room: room,
                assignedBots: assignedBots
            )
            .frame(height: editorHeight)
        }
        .onAppear {
            self.messages = room.allMessages()
            self.assignedBots = room.fetchRelatedBots()
        }
        .background(Style.roomBGColor)
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

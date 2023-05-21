//
//  RoomView.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/04.
//

import SwiftUI

struct RoomView: View {
    @AppStorage(UserDataManager.Keys.model.rawValue) private var selectedModel: String = "gpt-3.5-turbo"
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var appState: AppState

    @State private var messages: [Message] = []
    @State private var assignedBots: [Bot] = []

    @State private var targetBot: Bot?
    @State private var newText: String = ""

    @State private var showRoomSetting = false
    @State private var newMessageAdded = false
    @State private var editorHeight: CGFloat = 120

    let room: Room
    
    let spacerId = "BOTTOM_SPACER"
    
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
            
            
            ZStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack {
                            ForEach(messages) { message in
                                MessageRowView(message: message)
                                    .id(message)
                            }
                            .onAppear {
                                if messages.count > 0 {
                                    proxy.scrollTo(spacerId)
                                }
                            }
                            .onChange(of: newMessageAdded) { added in
                                if added {
                                    proxy.scrollTo(spacerId)
                                    newMessageAdded = false
                                }
                            }
                            
                            Spacer()
                                .frame(height: 64)
                                .id(spacerId)
                        }
                    }
                    
                }
                
                VStack {
                    Spacer()
                    Button {
                        Task {
                            await makeSummary()
                        }
                    } label: {
                        Text("ここまでの会話をまとめる")
                    }
                    .buttonStyle(.plain)
                    .padding(12)
                    .contentShape(RoundedRectangle(cornerRadius: 4))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .background(Color.roomBG)
                }
                .padding(8)
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
        .background(Color.roomBG)
    }
    
    private func makeSummary() async {
        appState.isBlocking = true
        
        let messages = MessageBuilder.buildSummarizeMessage(histories: self.messages)
        print("================ Messages:")
        messages.forEach { msg in
            print("\(msg)")
        }

        let params = ChatRequest(messages: messages, model: selectedModel)
        let response = await OpenAIClient.shared.chat(params)
        print(response ?? "None")

        if let message = response?.choices.first?.message {
            let summury = Summary.create(in: viewContext, text: message.content, room: room)
            self.messages.append(summury.toMessage())
            newMessageAdded = true
        }
        
        appState.isBlocking = false
    }
}

struct RoomView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let firstRoom = Room.fetchFirst(in: context)

        RoomView(room: firstRoom!)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(AppState())
    }
}

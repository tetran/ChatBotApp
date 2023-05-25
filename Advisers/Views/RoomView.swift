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
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    let room: Room
    
    private var messagesAfterLastSummary: [Message] {
       guard let summaryIndex = messages.lastIndex(where: { $0.messageType == .summary }) else {
           return messages
       }

       return Array(messages[(summaryIndex + 1)...])
    }
    
    private let spacerId = "BOTTOM_SPACER"
    private let numRequiredMesagesForSummary = 6 // 3往復
    
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
                    .disabled(messagesAfterLastSummary.count < numRequiredMesagesForSummary)
                }
                .padding(8)
            }

            RoomConversationView(
                newText: $newText,
                newMessageAdded: $newMessageAdded,
                messages: $messages,
                editorHeight: $editorHeight,
                alertMessage: $alertMessage,
                room: room,
                assignedBots: assignedBots
            )
            .frame(height: editorHeight)
        }
        .onAppear {
            self.messages = room.allMessages()
            self.assignedBots = room.fetchRelatedBots()
        }
        .onChange(of: alertMessage) { message in
            showAlert = !message.isEmpty
        }
        .alert("Error", isPresented: $showAlert, actions: {
            Button("OK") {
                alertMessage = ""
            }
        }, message: {
          Text(alertMessage)
        })
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
        do {
            let response = try await OpenAIClient.shared.chat(params)
            print("================ Response:")
            print(response)

            if let message = response.choices.first?.message {
                let summury = Summary.create(in: viewContext, text: message.content, room: room)
                self.messages.append(summury.toMessage())
                newMessageAdded = true
                SoundPlayer.shared.playRingtone()
            }
        } catch {
            alertMessage = error.localizedDescription
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

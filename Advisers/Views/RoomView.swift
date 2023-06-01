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

    @State private var showRoomSetting = false
    @State private var newMessageAdded = false
    @State private var editorHeight: CGFloat = 120
    @State private var noticeShowing = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    let room: Room
    
    @Binding var roomsWithUnreadMessages: [Room]

    private var messagesAfterLastSummary: [Message] {
       guard let summaryIndex = messages.lastIndex(where: { $0.messageType == .summary }) else {
           return messages
       }

       return Array(messages[(summaryIndex + 1)...])
    }
    
    private var canSummarize: Bool {
        messagesAfterLastSummary.count >= numRequiredMesagesForSummary && !appState.summarizing
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
                        .padding(8)
                }
                .sheet(isPresented: $showRoomSetting) {
                    RoomSettingView(room: room, assignedBots: $assignedBots)
                        .frame(minWidth: 400, minHeight: 400)
                }
                .buttonStyle(AppButtonStyle(
                    foregroundColor: .primary,
                    pressedForegroundColor: .primary.opacity(0.6),
                    backgroundColor: .gray.opacity(0.2),
                    pressedBackgroundColor: .gray.opacity(0.1)
                ))
                .padding(8)
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
                                    print("Scrolled on appear")
                                }
                            }
                            .onChange(of: newMessageAdded) { added in
                                if added {
                                    proxy.scrollTo(spacerId)
                                    newMessageAdded = false
                                    print("Scrolled by newMessageAdded")
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
                        appState.summarizing = true
                        Task {
                            await makeSummary()
                        }
                    } label: {
                        if appState.summarizing {
                            Text("まとめ作成中...")
                                .padding(.vertical, 4)
                                .padding(.horizontal, 12)
                                .foregroundColor(.accentColor)
                                .opacity(noticeShowing ? 1.0 : 0.0)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                                        noticeShowing.toggle()
                                    }
                                }
                        } else {
                            Text("ここまでの会話をまとめる")
                                .padding(4)
                        }
                    }
                    .buttonStyle(AppButtonStyle(
                        foregroundColor: .primary,
                        pressedForegroundColor: .primary.opacity(0.6),
                        backgroundColor: Color.roomBG,
                        pressedBackgroundColor: Color.roomBG.opacity(0.6)
                    ))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(appState.summarizing ? Color.accentColor : Color.gray, lineWidth: 1)
                    )
                    .disabled(!canSummarize)
                }
                .padding(8)
            }

            RoomConversationView(
                newMessageAdded: $newMessageAdded,
                messages: $messages,
                editorHeight: $editorHeight,
                alertMessage: $alertMessage,
                roomsWithUnreadMessages: $roomsWithUnreadMessages,
                room: room,
                assignedBots: assignedBots
            )
            .frame(height: editorHeight)
        }
        .onAppear {
            markMessagesAsRead()
            
            self.messages = room.allMessages()
            self.assignedBots = room.fetchRelatedBots()
        }
        .onChange(of: messages) { messages in
            markMessagesAsRead()
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
    
    private func markMessagesAsRead() {
        room.unreadBotMessages().forEach { $0.readAt = Date() }
        try! viewContext.save()
        
        if let index = roomsWithUnreadMessages.firstIndex(of: room) {
            roomsWithUnreadMessages.remove(at: index)
        }
    }
    
    private func makeSummary() async {
        defer {
            appState.summarizing = false
        }
        
        do {
            // Run summarization
            let messages = MessageBuilder.buildSummarizeMessage(histories: self.messages)
            print("================ Messages:")
            messages.forEach { msg in
                print("\(msg)")
            }

            let params = ChatRequest(messages: messages, model: selectedModel)
            
            let response = try await OpenAIClient.shared.chat(params)
            print("================ Response:\n\(response)")

            guard let summaryResponseMessage = response.choices.first?.message else {
                return
            }
            
            // Run translation
//            let translateMessage = MessageBuilder.buildTranslationMessage(source: summaryResponseMessage.content)
//            print("================ Messages:")
//            translateMessage.forEach { msg in
//                print("\(msg)")
//            }
//
//            let translateParams = ChatRequest(messages: translateMessage, model: selectedModel)
//            let translateResponse = try await OpenAIClient.shared.chat(translateParams)
//            print("================ Response:\n\(translateResponse)")
//
//            guard let translateResponseMessage = translateResponse.choices.first?.message else {
//                return
//            }
            
            let summury = Summary.create(in: viewContext, text: summaryResponseMessage.content, room: room)
            self.messages.append(summury.toMessage())
            newMessageAdded = true
            SoundPlayer.shared.playRingtone()
        } catch {
            alertMessage = error.localizedDescription
        }
    }
}

struct RoomView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let firstRoom = Room.fetchFirst(in: context)

        RoomView(room: firstRoom!, roomsWithUnreadMessages: .constant([]))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(AppState())
    }
}

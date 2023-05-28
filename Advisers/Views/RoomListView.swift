//
//  RoomListView.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/04.
//

import SwiftUI

struct RoomListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var appState: AppState

    @FetchRequest(
        entity: Room.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Room.createdAt, ascending: true)],
        animation: .default)
    private var rooms: FetchedResults<Room>
    
    @State private var selectedRoom: Room?
    @State private var showNewRoom = false
    @State private var newRoom: Room?
    @State private var roomsWithUnreadMessages: [Room] = []
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Room")
                    .font(.title)
                
                Divider()
                
                List(selection: $selectedRoom) {
                    ForEach(rooms) { room in
                        NavigationLink {
                            RoomView(room: room, roomsWithUnreadMessages: $roomsWithUnreadMessages)
                        } label: {
                            Circle()
                                .foregroundColor(roomsWithUnreadMessages.contains(room) ? .accentColor : .clear)
                                .frame(width: 10, height: 10)
                            Text(room.name)
                                .font(.title2)
                                .padding(8)
                        }
                        .tag(room)
                        .disabled(appState.summarizing)
                    }
                }
                .frame(minWidth: 240)
                .navigationTitle("Rooms")
                
                Button {
                    showNewRoom = true
                } label: {
                    Label("Roomを追加する", systemImage: "plus")
                        .font(.title2)
                        .padding(8)
                }
                .padding()
                .buttonStyle(AppButtonStyle(
                    foregroundColor: .white,
                    pressedForegroundColor: .white.opacity(0.6),
                    backgroundColor: .accentColor,
                    pressedBackgroundColor: .accentColor.opacity(0.6)
                ))
                .sheet(isPresented: $showNewRoom) {
                    NewRoomView(newRoom: $newRoom)
                        .frame(minWidth: 400, minHeight: 200)
                }
                .disabled(appState.summarizing)
            }
        }
        .onAppear {
            selectedRoom = rooms.first
            roomsWithUnreadMessages = rooms.filter { !$0.unreadBotMessages().isEmpty }
        }
        .onChange(of: newRoom) { newRoom in
            if let newRoom = newRoom {
                selectedRoom = newRoom
                self.newRoom = nil
            }
        }
    }
}

struct RoomListView_Previews: PreviewProvider {
    static var previews: some View {
        RoomListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .frame(width: 1000, height: 600)
            .environmentObject(AppState())
    }
}

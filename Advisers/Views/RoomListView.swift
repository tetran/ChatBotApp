//
//  RoomListView.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/04.
//

import SwiftUI

struct RoomListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: Room.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Room.createdAt, ascending: true)],
        animation: .default)
    private var rooms: FetchedResults<Room>
    
    @State private var selectedRoom: Room?
    @State private var showNewRoom = false
    @State private var newRoom: Room?
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Room")
                    .font(.title)
                
                Divider()
                
                List(selection: $selectedRoom) {
                    ForEach(rooms) { room in
                        NavigationLink {
                            RoomView(room: room)
                        } label: {
                            Text(room.name)
                                .font(.title2)
                                .padding(8)
                        }
                        .tag(room)
                    }
                }
                .frame(minWidth: 300)
                .navigationTitle("Rooms")
                
                Button {
                    showNewRoom = true
                } label: {
                    Label("部屋を追加する", systemImage: "plus")
                        .padding()
                }
                .padding()
                .buttonStyle(.plain)
                .sheet(isPresented: $showNewRoom) {
                    NewRoomView(newRoom: $newRoom)
                        .frame(minWidth: 400, minHeight: 200)
                }
            }
        }
        .onAppear {
            selectedRoom = rooms.first
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
    }
}

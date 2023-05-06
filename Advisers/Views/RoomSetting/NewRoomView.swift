//
//  NewRoomView.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/04.
//

import SwiftUI

struct NewRoomView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var roomName: String = ""
    @State private var newRoom: Room?
    @State private var isSettingViewActive = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("New Room")) {
                        TextField("名前", text: $roomName)
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
                        let room = Room(context: viewContext)
                        room.id = UUID()
                        room.name = roomName
                        room.createdAt = Date()
                        room.updatedAt = Date()
                        try! viewContext.save()

                        newRoom = room
                        isSettingViewActive = true
                    } label: {
                        Text("次へ")
                    }
                    .padding(.leading)
                    .disabled(roomName.isEmpty)
                    .navigationDestination(isPresented: $isSettingViewActive) {
                        if let newRoom = newRoom {
                            RoomSettingView(room: newRoom)
                                .frame(minWidth: 400, minHeight: 400)
                        }
                    }
                }
                .padding()
            }
        }
        .onChange(of: isSettingViewActive) { isActive in
            if !isActive {
                dismiss()
            }
        }
    }
}

struct NewRoomView_Previews: PreviewProvider {
    static var previews: some View {
        NewRoomView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

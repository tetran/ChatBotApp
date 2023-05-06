//
//  ModifyRoomNameView.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/04.
//

import SwiftUI

struct ModifyRoomNameView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var roomName: String = ""
    let room: Room
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("ルーム名を変更する")) {
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
                    room.name = roomName
                    try! viewContext.save()
                    dismiss()
                } label: {
                    Text("変更を保存する")
                }
                .padding(.leading)
                .disabled(roomName.isEmpty)
            }
            .padding()
        }
        .onAppear {
            roomName = room.name
        }
    }
}

struct ModifyRoomNameView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let firstRoom = Room.fetchFirst(in: context)
        
        ModifyRoomNameView(room: firstRoom!)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

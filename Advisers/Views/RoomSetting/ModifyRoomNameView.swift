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
            HStack {
                Text("Room名を変更する")
                    .font(.title)
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .bold()
                }
                .buttonStyle(AppButtonStyle.closeButton)
            }
            .padding()
            
            Form {
                TextField("名前", text: $roomName)
                    .padding()
            }
            .padding(20)
            
            HStack {
                Spacer()
                
                Button {
                    room.name = roomName
                    try! viewContext.save()
                    dismiss()
                } label: {
                    Text("変更を保存する")
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                }
                
                .buttonStyle(AppButtonStyle(
                    foregroundColor: .primary,
                    pressedForegroundColor: .primary.opacity(0.6),
                    backgroundColor: .gray.opacity(0.2),
                    pressedBackgroundColor: .gray.opacity(0.1)
                ))
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

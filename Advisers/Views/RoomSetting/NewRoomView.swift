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
    @Binding var newRoom: Room?
    
    var body: some View {
        VStack {
            HStack {
                Text("新規Room作成")
                    .font(.title2)
                
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
                    let room = Room(context: viewContext)
                    room.id = UUID()
                    room.name = roomName
                    room.createdAt = Date()
                    room.updatedAt = Date()
                    try! viewContext.save()

                    newRoom = room
                    dismiss()
                } label: {
                    Text("作成")
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
    }
}

struct NewRoomView_Previews: PreviewProvider {
    static var previews: some View {
        NewRoomView(newRoom: .constant(nil))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

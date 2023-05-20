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
                .buttonStyle(.plain)
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
                }
                .padding(.leading)
                .buttonStyle(.plain)
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

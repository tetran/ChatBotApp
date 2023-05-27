//
//  BasicRoomSettingView.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/04.
//

import SwiftUI

struct BasicRoomSettingView: View {
    @State private var showRoomNameEdit = false
    let room: Room
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Room名")
                .font(.caption2)
            HStack {
                Text(room.name)
                
                Spacer()
                
                Button {
                    showRoomNameEdit = true
                } label: {
                    Text("編集")
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                }
                .buttonStyle(AppButtonStyle(
                    foregroundColor: .primary,
                    pressedForegroundColor: .primary.opacity(0.6),
                    backgroundColor: .gray.opacity(0.2),
                    pressedBackgroundColor: .gray.opacity(0.1)
                ))
                .sheet(isPresented: $showRoomNameEdit) {
                    ModifyRoomNameView(room: room)
                        .frame(minWidth: 400, minHeight: 200)
                }
            }
            .padding(.vertical, 2)
            
            Text("ID")
                .font(.caption2)
                .padding(.top)
            Text(room.id.uuidString)
                .padding(.vertical, 2)
            
            Text("作成日")
                .font(.caption2)
                .padding(.top)
            Text(room.createdAt.appFormat())
                .padding(.vertical, 2)
        }
        .padding()
    }
}

struct BasicRoomSettingView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let firstRoom = Room.fetchFirst(in: context)
        BasicRoomSettingView(room: firstRoom!)
    }
}

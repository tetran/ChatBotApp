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
            Text("ルーム名")
                .font(.title2)
            HStack {
                Text(room.name)
                
                Spacer()
                
                Button {
                    showRoomNameEdit = true
                } label: {
                    Text("編集")
                }
                .padding()
                .buttonStyle(.plain)
                .sheet(isPresented: $showRoomNameEdit) {
                    ModifyRoomNameView(room: room)
                        .frame(minWidth: 400, minHeight: 200)
                }
            }
            .padding(.bottom)
            
            Text("ID")
                .font(.title2)
                .padding(.top)
            Text(room.id.uuidString)
                .padding(.vertical)
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

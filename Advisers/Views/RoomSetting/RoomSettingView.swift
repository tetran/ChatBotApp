//
//  RoomSettingView.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/04.
//

import SwiftUI

struct RoomSettingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selection: Tab = .bot
    
    let room: Room
    
    @Binding var assignedBots: [Bot]

    enum Tab {
        case basic
        case bot
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("\(room.name) の設定")
                    .font(.title)
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
            
            TabView(selection: $selection) {
                RoomBotSettingView(room: room, assignedBots: $assignedBots)
                    .tabItem {
                        Label("Bot設定", systemImage: "list.bullet")
                    }
                    .tag(Tab.bot)
                
                BasicRoomSettingView(room: room)
                    .tabItem {
                        Label("Room情報", systemImage: "star")
                    }
                    .tag(Tab.basic)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct RoomSettingView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let firstRoom = Room.fetchFirst(in: context)
        
        RoomSettingView(room: firstRoom!, assignedBots: .constant([]))
    }
}

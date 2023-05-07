//
//  AppSettingView.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/04.
//

import SwiftUI

struct AppSettingView: View {
    @State private var selection: Tab = .basic

    enum Tab {
        case basic
        case bot
        case dev
    }
    
    var body: some View {
        TabView(selection: $selection) {
            AppBasicSettingView()
                .tabItem {
                    Label("基本情報", systemImage: "gear")
                }
                .tag(Tab.basic)
                .frame(minHeight: 300)

            BotSettingView()
                .tabItem {
                    Label("Bot", systemImage: "poweroutlet.type.b")
                }
                .tag(Tab.bot)
                .frame(minHeight: 600)
            
            DevMenuView()
                .tabItem {
                    Label("Dev", systemImage: "hammer")
                }
                .tag(Tab.dev)
                .frame(minHeight: 300)
        }
        .frame(minWidth: 600)
    }
}

struct AppSettingView_Previews: PreviewProvider {
    static var previews: some View {
        AppSettingView()
    }
}

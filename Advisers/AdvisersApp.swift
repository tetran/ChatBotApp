//
//  AdvisersApp.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/04.
//

import SwiftUI

@main
struct AdvisersApp: App {
    @StateObject private var appState = AppState()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(appState)
        }
        
        Settings {
            AppSettingView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(appState)
        }
    }
}

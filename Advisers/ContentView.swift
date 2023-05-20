//
//  ContentView.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/04.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            RoomListView()
                .frame(minWidth: 800, minHeight: 600)
            
            if appState.isBlocking {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(2)
                    )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(AppState())
    }
}

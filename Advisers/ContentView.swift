//
//  ContentView.swift
//  Advisers
//
//  Created by kkoichi on 2023/05/04.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        RoomListView()
            .frame(minWidth: 800, minHeight: 600)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

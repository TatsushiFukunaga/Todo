//
//  TodoApp.swift
//  Todo
//
//  Created by Tatsushi Fukunaga on 2020/10/04.
//

import SwiftUI

@main
struct TodoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

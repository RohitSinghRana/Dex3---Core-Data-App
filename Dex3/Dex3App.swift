//
//  Dex3App.swift
//  Dex3
//
//  Created by Rohit Singh Rana on 14/01/25.
//

import SwiftUI

@main
struct Dex3App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

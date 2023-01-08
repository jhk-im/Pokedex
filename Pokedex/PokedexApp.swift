//
//  PokedexApp.swift
//  Pokedex
//
//  Created by HUN on 2023/01/08.
//

import SwiftUI

@main
struct PokedexApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

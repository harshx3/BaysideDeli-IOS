//
//  BaysideDeliApp.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 11/25/25.
//

import SwiftUI
import SwiftData

@main
struct BaysideDeliApp: App {
    var body: some Scene {
        WindowGroup {
            MenuView()
                .preferredColorScheme(.light)

        }
        //Injecting Database from CartItem.Swift
        // This creates the file "default.store" on the user's phone
        .modelContainer(for: CartItem.self)
            }
}



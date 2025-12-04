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
    
    // 1. Create the Global Auth State (Source of Truth)
    @StateObject private var appViewModel = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            // 2. Change Root View to MainTabView
            MainTabView()
                .environmentObject(appViewModel) // 3. Inject it everywhere!
                .modelContainer(for: CartItem.self)
                .preferredColorScheme(.light)
        }
    }
}


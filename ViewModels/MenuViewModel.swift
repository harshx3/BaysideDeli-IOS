//
//  MenuViewModel.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 11/20/25.
//

import Foundation
import Combine

let sharedSupabaseManager = SupabaseManager()

@MainActor
final class MenuViewModel: ObservableObject {
    @Published var items: [MenuItem] = []
    @Published var errorMessage: String?

    private let menuService: MenuService
    
    init(menuService: MenuService = sharedSupabaseManager.menuService) {
        self.menuService = menuService
    }

    func load() async {
        guard items.isEmpty else { return }
        
        do {
            items = try await menuService.fetchMenuItems()
            print("Items Data:", items)
        } catch {
            errorMessage = error.localizedDescription
            print("Fetch error: ", error)
        }
    }
}

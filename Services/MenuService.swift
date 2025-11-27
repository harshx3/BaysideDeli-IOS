//
//  MenuService.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 11/25/25.
//

import Foundation
import Supabase


protocol MenuServiceProtocol {
    func fetchMenuItems() async throws -> [MenuItem]
}

class MockMenuService: MenuServiceProtocol {
    func fetchMenuItems() async throws -> [MenuItem] {
        // Simulating a network delay of 1 second
        try await  Task.sleep(nanoseconds: 1 * 1_000_000_000)
        
        return [
            MenuItem(
                            id: UUID(),
                            categoryId: UUID(),
                            name: "Classic Burger",
                            description: "Juicy beef patty with cheddar.",
                            price: 12.99,
                            imageURL: "",
                            isActive: true,
                            sortOrder: 1
                        ),
                        MenuItem(
                            id: UUID(),
                            categoryId: UUID(),
                            name: "Cobb Salad",
                            description: "Fresh greens with chicken.",
                            price: 10.50,
                            imageURL: "",
                            isActive: true,
                            sortOrder: 2
                        ),
                        MenuItem(
                            id: UUID(),
                            categoryId: UUID(),
                            name: "Fries",
                            description: "Crispy golden potato fries.",
                            price: 4.99,
                            imageURL: "",
                            isActive: true,
                            sortOrder: 3
                        )        ]
    }
}

class SupabaseMenuService: MenuServiceProtocol {
    func fetchMenuItems() async throws -> [MenuItem] {
        let client = SupabaseManager.shared.client
        
        // Fetching items, ensuring we only get active ones, and sort them as well
        let items: [MenuItem] = try await client
            .from("menu_items")
            .select()
            .eq("is_active", value: true) // filter: only show active items
            .order("sort_order", ascending: true)
            .execute()
            .value
        
        return items
    }
}


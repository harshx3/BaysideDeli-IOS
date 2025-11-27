//
//  MenuService.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 11/25/25.
//

import Foundation

protocol MenuServiceProtocol {
    func fetchMenuItems() async throws -> [MenuItem]
}

class MockMenuService: MenuServiceProtocol {
    func fetchMenuItems() async throws -> [MenuItem] {
        // Simulating a network delay of 1 second
        try await  Task.sleep(nanoseconds: 1 * 1_000_000_000)
        
        return [
            MenuItem(id: 1, name: "Classic Burger", description: "Juicy beef patty with cheddar.", base_price: 12.99, imageURL: nil),
                        MenuItem(id: 2, name: "Cobb Salad", description: "Fresh greens with chicken and egg.", base_price: 10.50, imageURL: nil),
                        MenuItem(id: 3, name: "Fries", description: "Crispy golden potato fries.", base_price: 4.99, imageURL: nil)
        ]
    }
}

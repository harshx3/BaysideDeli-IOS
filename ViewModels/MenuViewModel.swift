//
//  MenuViewModel.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 11/20/25.
//

import Foundation
import Combine

@MainActor
final class MenuViewModel: ObservableObject {
    @Published var items: [MenuItem] = []
    @Published var errorMessage: String?

    private let service = MenuServiceRaw()

    func load() async {
        do {
            items = try await service.fetchMenuItems()
            print("Items Data:",items)
        } catch {
            errorMessage = error.localizedDescription
            print("Fetch error:", error)
        }
    }
}

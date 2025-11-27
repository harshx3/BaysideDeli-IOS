//
//  MenuViewModel.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 11/26/25.
//

import Foundation
import Combine

@MainActor
class MenuViewModel: ObservableObject {
    // STATE: What the UI needs to show
    @Published var items: [MenuItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // DEPENDENCY: Who gets the data?
    private let service: MenuServiceProtocol
    
    //INJECTION: we can swap the service
    // if no service is provided, use the Mock by default (for now)
    init(service: MenuServiceProtocol = MockMenuService()) {
        self.service = service
    }
    
    // 4. INTENT: The action to perform
    func loadMenu() async {
        // Update UI state
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            // Wait for data
            self.items = try await service.fetchMenuItems()
        } catch {
            self.errorMessage = "Failed to load menu: \(error.localizedDescription)"
        }
    }
}

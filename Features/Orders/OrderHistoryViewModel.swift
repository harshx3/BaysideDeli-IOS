//
//  OrderHistoryViewModel.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 12/2/25.
//

import Foundation
import Combine

@MainActor
class OrderHistoryViewModel: ObservableObject {
    @Published var orders: [Order] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let service = OrderService()
    
    func loadOrders(userId: UUID) async {
        isLoading = true
        errorMessage = nil
        
        do {
            self.orders = try await service.fetchOrders(userId: userId)
            
        } catch {
            self.errorMessage = "Failed to load orders: \(error.localizedDescription)"
        }
        isLoading = false
    }
}

//
//  OrderService.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 11/29/25.
//

import Foundation
import Supabase

struct OrderService {
    
    // 1. Calculate and Send
    func placeOrder(cartItems: [CartItem], notes: String?) async throws {
        let client = SupabaseManager.shared.client
        
        // A. MATH: Calculate totals locally
        let subtotal = cartItems.reduce(0) { $0 + $1.totalPrice }
        let tax = subtotal * 0.08875 // NYC Tax (~8.875%). Change this to your local rate!
        let total = subtotal + tax
        
        // B. CREATE ORDER: Send the header first
        let newOrder = Order(
            id: nil, // Server will generate this
            subtotal: subtotal,
            tax: tax,
            total: total,
            notes: notes
        )
        
        // "insert" returns the data so we can get the new ID
        let createdOrder: Order = try await client
            .from("orders")
            .insert(newOrder)
            .select() // Important: Ask Supabase to send back the created row
            .single() // We expect exactly 1 result
            .execute()
            .value
        
        // C. GUARD: Ensure we got an ID back
        guard let orderID = createdOrder.id else {
            throw URLError(.badServerResponse)
        }
        
        print("✅ Order Created: #\(orderID)")
        
        // D. CREATE ITEMS: Link them to the new Order ID
        let orderItems = cartItems.map { item in
            OrderItemDTO(
                order_id: orderID,
                menu_item_id: item.menuItemID,
                name_snapshot: item.name,
                quantity: item.quantity,
                unit_price: item.price
            )
        }
        
        // Bulk Insert all items at once
        try await client
            .from("order_items")
            .insert(orderItems)
            .execute()
        
        print("✅ Order Items Saved!")
    }
}

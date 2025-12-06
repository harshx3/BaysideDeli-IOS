//
//  Order.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 11/29/25.
//

import Foundation

// 1. The Order Header (Matches public.orders)
struct Order: Encodable, Decodable {
    var id: Int64? // Optional, because we don't know it until the server responds
    let status: String = "new"
    let subtotal: Double
    let tax: Double
    let total: Double
    let notes: String?
    let user_id: UUID?
    
    // We match your SQL column names
    enum CodingKeys: String, CodingKey {
        case id
        case status
        case subtotal
        case tax
        case total
        case notes
        case user_id = "customer_id"
        // We ignore store_id, customer_id, etc. for now (they will be null)
    }
}

// 2. The Order Line Item (Matches public.order_items)
struct OrderItemDTO: Encodable {
    let order_id: Int64
    let menu_item_id: UUID
    let name_snapshot: String
    let quantity: Int
    let unit_price: Double
}

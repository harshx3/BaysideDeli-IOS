//
//  MenuItem.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 11/25/25.
//

import Foundation

struct MenuItem: Identifiable, Codable {
    // Codable allows Swift to automaticaly convert that JSON text into your MenuItem
    let id: UUID
    let categoryId: UUID?
    let name: String
    let description: String?
    let price: Double
    let imageURL: String?
    let isActive: Bool?
    let sortOrder: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case categoryId = "category_id"
        case name
        case description
        case price = "base_price"
        case imageURL = "image_url"
        case isActive = "is_active"
        case sortOrder = "sort_order"
    }
}

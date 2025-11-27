//
//  MenuItem.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 11/25/25.
//

import Foundation

struct MenuItem: Identifiable, Codable {
    // Codable allows Swift to automaticaly convert that JSON text into your MenuItem
    let id: Int
    let name: String
    let description: String?
    let base_price: Double
    let imageURL: String?
}

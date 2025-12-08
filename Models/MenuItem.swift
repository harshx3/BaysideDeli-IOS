//
//  MenuItem.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 11/20/25.
//

import Foundation

struct MenuItem: Identifiable, Decodable {
    let id: String
    let category_id: String?
    let name: String
    let description: String?
    let base_price: Double
    var image_url: String?
    let is_active: Bool?
}

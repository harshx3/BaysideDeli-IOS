//
//  CartItem.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 11/27/25.
//

import Foundation
import SwiftData

//@Model Macro tells Swift: "Please turn this class into a Database Table automatically"
@Model
final class CartItem {
    //Properties (Columns in the DB)
    var id: UUID
    var menuItemID: UUID
    var name: String
    var price: Double
    var imageURL: String
    var quantity: Int
    var instructions: String?
    
    // Computed Property(Logic)
    var totalPrice: Double {
        price * Double(quantity)
    }
    
    // Init (How to create one)
    init(menuItem: MenuItem, quantity: Int = 1) {
        self.id = UUID()
        self.menuItemID = menuItem.id
        self.name = menuItem.name
        self.price = menuItem.price
        self.imageURL = menuItem.imageURL ?? ""
        self.quantity = quantity
        self.instructions = nil
    }
}

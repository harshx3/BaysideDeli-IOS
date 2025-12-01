//
//  CartView.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 11/28/25.
//

import SwiftUI
import SwiftData
import Kingfisher

struct CartView: View {
    
    // 1. The Database Connection
    @Environment(\.modelContext) private var context
    
    // 2. The Live Query
    // This fetches ALL CartItems from the database automatically.
    // It watches for changes. If a new item is added, this array updates instantly.
    @Query private var cartItems: [CartItem]
    
    @State private var isCheckingOut = false
    
    // 3. Calculated Total
    private var totalPrice: Double {
        cartItems.reduce(0) { $0 + $1.totalPrice }
    }
    
    var body: some View {
        List {
            // Section 1: The Items
            Section {
                if cartItems.isEmpty {
                    ContentUnavailableView(
                        "Your Cart is Empty",
                        systemImage: "cart",
                        description: Text("Go add some delicious burgers!")
                    )
                } else {
                    ForEach(cartItems) { item in
                        HStack {
                            // Mini Image
                            if let url = URL(string: item.imageURL) {
                                KFImage(url)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(8)
                                    .clipped()
                            }
                            
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text("Qty: \(item.quantity)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            Text(item.totalPrice, format: .currency(code: "USD"))
                                .bold()
                        }
                    }
                    // 4. The Delete Action
                    .onDelete(perform: deleteItems)
                }
            }
            
            // Section 2: The Summary
            if !cartItems.isEmpty {
                Section {
                    HStack {
                        Text("Total")
                            .font(.headline)
                        Spacer()
                        Text(totalPrice, format: .currency(code: "USD"))
                            .font(.title3)
                            .bold()
                            .foregroundStyle(.green)
                    }
                }
                
                // Section 3: Checkout Button (Placeholder)
                Section {
                    Button(action: {
                        Task {
                            await performCheckout()
                        }
                    }) {
                        if isCheckingOut {
                            ProgressView()
                        } else {
                            Text("Checkout")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.blue)
                        }
                    }
                    .disabled(isCheckingOut) // Prevent double taps
                }
            }
        }
        .navigationTitle("My Cart")
    }
    
    // 5. The Delete Logic
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let itemToDelete = cartItems[index]
            context.delete(itemToDelete)
        }
    }
        // No need to save manually! SwiftData handles it.
        
        private func performCheckout() async {
            isCheckingOut = true
            do {
                let service = OrderService()
                // We pass 'nil' for notes for now
                try await service.placeOrder(cartItems: cartItems, notes: nil)
                
                // Success! Clear the local cart
                try? context.delete(model: CartItem.self)
                print("Cart Cleared")
                
            } catch {
                print("Checkout Failed: \(error)")
            }
            isCheckingOut = false
        
    }
}



#Preview {
    // Preview with In-Memory DB
    NavigationStack {
        CartView()
            .modelContainer(for: CartItem.self, inMemory: true)
    }
}

//
//  SwiftUIView.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 11/27/25.
//

import SwiftUI
import Kingfisher
import SwiftData

struct MenuItemDetailView: View {
    
    let item: MenuItem
    
    // Database Connection
    // This grabs the "Scratchpad" from the environment automatically
    @Environment(\.modelContext) private var context
    
    // UI State for the Alert
    @State private var showConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Image banner
                if let urlString = item.imageURL, let url = URL(string: urlString) {
                    KFImage(url)
                        .placeholder {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 250)
                        .clipped()
                }
                else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 250)
                        .overlay(Image(systemName: "photo")
                            .scaleEffect(2))
                }
                
                // Content Area
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(item.name)
                            .font(.title)
                            .bold()
                        
                        Spacer()
                        
                        Text(item.price, format: .currency(code: "USD"))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(8)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(8)
                    }
                    
                    Text(item.description ?? "")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .lineSpacing(4)
                    
                    Spacer()
                    Button(action: addToCart) {
                        Text("Add to Cart")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                        
                    }
                    .padding(.top, 20)
                }
            }
        }
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Added to Cart", isPresented: $showConfirmation) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("\(item.name) is now in your cart.")
        }
        
    }
        // Add to Cart logic
    private func addToCart() {
            // 1. Define the ID we are looking for
            let targetID = item.id
            
            // 2. Create a "Fetch Descriptor" (The Search Query)
            // We use a #Predicate to filter the database.
            // Logic: "Find me any CartItem where the menuItemID matches this item's ID."
            let predicate = #Predicate<CartItem> { cartItem in
                cartItem.menuItemID == targetID
            }
            var descriptor = FetchDescriptor(predicate: predicate)
            
            // 3. Limit the search (Optimization)
            // We only need 1 match to know it exists.
            descriptor.fetchLimit = 1
            
            do {
                // 4. Run the search
                let duplicateItems = try context.fetch(descriptor)
                
                if let existingItem = duplicateItems.first {
                    // CASE A: It exists! Just update the quantity.
                    existingItem.quantity += 1
                    print("Updated quantity for \(item.name)")
                } else {
                    // CASE B: It's new! Create a new row.
                    let newItem = CartItem(menuItem: item, quantity: 1)
                    context.insert(newItem)
                    print("Inserted new row for \(item.name)")
                }
                
                // 5. Success Feedback
                showConfirmation = true
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                
            } catch {
                print("Failed to fetch cart items: \(error)")
            }
        }
}

#Preview {
    NavigationStack {
        MenuItemDetailView(item: MenuItem(
            id: UUID(),
            categoryId: UUID(),
            name: "Test Burger",
            description: "A delicious test burger with all the fixings",
            price: 9.99,
            imageURL: nil,
            isActive: true,
            sortOrder: 1
        ))
        .modelContainer(for: CartItem.self, inMemory: true)
    }
}


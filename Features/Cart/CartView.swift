//
//  CartView.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 11/28/25.
//

import SwiftUI
import SwiftData
import Kingfisher
import Supabase

struct CartView: View {
    
    // 1. Dependencies
    @Environment(\.modelContext) private var context
    @EnvironmentObject var appViewModel: AppViewModel // To check login status
    
    // 2. Data
    @Query private var cartItems: [CartItem]
    @State private var isCheckingOut = false
    @State private var showLoginSheet = false // Controls the login popup
    
    private var totalPrice: Double {
        cartItems.reduce(0) { $0 + $1.totalPrice }
    }
    
    var body: some View {
        List {
            // --- SECTION 1: ITEMS ---
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
                    .onDelete(perform: deleteItems)
                }
            }
            
            // --- SECTION 2: TOTAL & CHECKOUT ---
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
                
                Section {
                    Button(action: handleCheckoutTap) {
                        if isCheckingOut {
                            ProgressView()
                        } else {
                            Text("Checkout")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.blue)
                        }
                    }
                    .disabled(isCheckingOut)
                }
            }
        }
        .navigationTitle("My Cart")
        // --- LOGIN SHEET LOGIC ---
        .sheet(isPresented: $showLoginSheet) {
            NavigationStack {
                AuthView()
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Cancel") { showLoginSheet = false }
                        }
                    }
            }
            .presentationDetents([.medium])
        }
        // PRO MOVE: Auto-close sheet when user logs in successfully
        .onChange(of: appViewModel.isAuthenticated) { oldValue, newValue in
            if newValue == true {
                showLoginSheet = false
            }
        }
    }
    
    // MARK: - Logic Helpers
    
    // 1. The Gatekeeper
    private func handleCheckoutTap() {
        if appViewModel.isAuthenticated {
            // User is logged in -> Go!
            Task { await performCheckout() }
        } else {
            // User is Guest -> Stop! Show Login.
            showLoginSheet = true
        }
    }
    
    // 2. The Heavy Lifting
    private func performCheckout() async {
            isCheckingOut = true
            do {
                let service = OrderService()
                let userId = appViewModel.currentUser?.id
                
                // 1. Send to Server
                try await service.placeOrder(
                    cartItems: cartItems,
                    notes: nil,
                    userId: userId
                )
                
                // 2. THE NUCLEAR FIX (Main Actor)
                // We jump to the Main Thread to ensure the UI updates instantly.
                await MainActor.run {
                    // Delete every single item
                    for item in cartItems {
                        context.delete(item)
                    }
                    
                    // FORCE SAVE the deletion to disk
                    try? context.save()
                }
                
                print("✅ Checkout Success! Cart cleared.")
                
            } catch {
                print("❌ Checkout Failed: \(error)")
            }
            isCheckingOut = false
        }
    
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let itemToDelete = cartItems[index]
            context.delete(itemToDelete)
        }
    }
}


#Preview {
    NavigationStack {
        CartView()
            .environmentObject(AppViewModel()) // <--- ADD THIS
            .modelContainer(for: CartItem.self, inMemory: true)
    }
}

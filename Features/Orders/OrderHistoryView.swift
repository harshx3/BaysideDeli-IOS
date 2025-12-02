//
//  OrderHistoryView.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 12/2/25.
//

import SwiftUI

struct OrderHistoryView: View {
    
    @StateObject private var viewModel = OrderHistoryViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading history...")
                } else if let error = viewModel.errorMessage {
                    ContentUnavailableView(
                        "Error",
                        systemImage: "exclamationmark.triangle",
                        description: Text(error)
                    )
                } else if viewModel.orders.isEmpty {
                    ContentUnavailableView(
                        "No Orders Yet",
                        systemImage: "doc.text.magnifyingglass",
                        description: Text("Go order a burger!")
                    )
                } else {
                    // THE LIST
                    List(viewModel.orders, id: \.id) { order in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Order #\(order.id ?? 0)")
                                    .font(.headline)
                                
                                // Status Badge
                                Text(order.status.uppercased())
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(statusColor(for: order.status).opacity(0.2))
                                    .foregroundStyle(statusColor(for: order.status))
                                    .cornerRadius(4)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text(order.total, format: .currency(code: "USD"))
                                    .bold()
                                
                                // Simple date logic (we will improve this later)
                                Text("Just now")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await viewModel.loadOrders()
                    }
                }
            }
            .navigationTitle("Order History")
            .task {
                await viewModel.loadOrders()
            }
        }
    }
    
    // Helper for Status Colors
    private func statusColor(for status: String) -> Color {
        switch status.lowercased() {
        case "new": return .blue
        case "cooking": return .orange
        case "delivered": return .green
        case "cancelled": return .red
        default: return .gray
        }
    }
}

#Preview {
    OrderHistoryView()
}

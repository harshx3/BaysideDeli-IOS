//
//  OrderHistoryView.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 12/2/25.
//

import SwiftUI
import Supabase

struct OrderHistoryView: View {
    
    @StateObject private var viewModel = OrderHistoryViewModel()
    @EnvironmentObject var appViewModel: AppViewModel // <--- 1. Access Auth State
    
    var body: some View {
        NavigationStack {
            Group {
                // SCENARIO A: Guest User (Logged Out)
                if !appViewModel.isAuthenticated {
                    ContentUnavailableView(
                        "Log In Required",
                        systemImage: "person.crop.circle.badge.exclamationmark",
                        description: Text("Please log in to view your past orders.")
                    )
                }
                // SCENARIO B: Logged In but Loading
                else if viewModel.isLoading {
                    ProgressView("Loading history...")
                }
                // SCENARIO C: Logged In but Error
                else if let error = viewModel.errorMessage {
                    ContentUnavailableView(
                        "Error",
                        systemImage: "exclamationmark.triangle",
                        description: Text(error)
                    )
                }
                // SCENARIO D: Logged In but Empty History
                else if viewModel.orders.isEmpty {
                    ContentUnavailableView(
                        "No Orders Yet",
                        systemImage: "doc.text.magnifyingglass",
                        description: Text("Go order a burger!")
                    )
                }
                // SCENARIO E: Show The List!
                else {
                    List(viewModel.orders, id: \.id) { order in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Order #\(order.id ?? 0)")
                                    .font(.headline)
                                Text(order.status.uppercased())
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.2)) // Simplified color for now
                                    .foregroundStyle(.blue)
                                    .cornerRadius(4)
                            }
                            Spacer()
                            Text(order.total, format: .currency(code: "USD"))
                                .bold()
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        // Refresh with current ID
                        if let id = appViewModel.currentUser?.id {
                            await viewModel.loadOrders(userId: id)
                        }
                    }
                }
            }
            .navigationTitle("Order History")
            .task {
                // Only load if we have a valid User ID
                if let id = appViewModel.currentUser?.id {
                    await viewModel.loadOrders(userId: id)
                }
            }
        }
    }
}
#Preview {
    NavigationStack {
        OrderHistoryView()
            // 💉 Inject the missing dependency
            .environmentObject(AppViewModel())
    }
}

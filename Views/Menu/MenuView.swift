//
//  MenuView.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 11/20/25.
//

import SwiftUI


struct MenuView: View {
    @StateObject private var vm = MenuViewModel()

    var body: some View {
        NavigationView {
            List {
                if vm.items.isEmpty {
                    Text("Loading…")
                        .foregroundColor(.secondary)
                }

                ForEach(vm.items) { item in
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.name)
                                .font(.headline)
                           
                            FetchImage(urlString: item.image_url!, width: 100, height: 100)

                            if let desc = item.description {
                                Text(desc)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                            }

                            Text("$\(String(format: "%.2f", item.base_price))")
                                .font(.caption)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Menu")
            .task { await vm.load() }
            .alert("Error", isPresented: Binding<Bool>(
                get: { vm.errorMessage != nil },
                set: { if !$0 { vm.errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) { vm.errorMessage = nil }
            } message: {
                Text(vm.errorMessage ?? "")
            }
        }
    }
}

#Preview {
    MenuView()
}

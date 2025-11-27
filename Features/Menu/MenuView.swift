//
//  ContentView.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 11/25/25.
//

import SwiftUI

struct MenuView: View {
    
    // Creating the ViewModel here.
    // By default, it uses the MockService inside, so Preview work instantly
    @StateObject private var viewModel = MenuViewModel()
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Cooking...")
                } else if let error = viewModel.errorMessage {
                    //Error State
                    ContentUnavailableView(
                        "Oops!",
                        systemImage: "exclamationmark.triangle",
                        description: Text(error)
                    )
                } else {
                    //Success State
                    List(viewModel.items) {
                        item in
                        HStack {
                         Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                            
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.description!)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                            Spacer()
                            
                            Text(item.base_price, format: .currency(code: "USD"))
                                .font(.subheadline)
                                .bold()
                        }
                    }
                    .listStyle(.plain)
                    
                }
            }
            .navigationTitle("Menu")
            .task {
                // This triggers the data loan when the View appears
                await viewModel.loadMenu()
            }
        }
    }
}

#Preview {
    MenuView()
}

//
//  SwiftUIView.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 11/27/25.
//

import SwiftUI
import Kingfisher

struct MenuItemDetailView: View {
    
    let item: MenuItem
    
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
                    Button(action: {
                        print("Add to cart: \(item.name)")
                    }) {
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
    }
}


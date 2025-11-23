//
//  FetchImage.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 11/21/25.
//

import SwiftUI

struct FetchImage: View {
    let urlString: String
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        let encodedURL = urlString.urlEncoded ?? urlString
        let fileURL = URL(string: encodedURL)

        AsyncImage(url: fileURL) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: self.width, height: self.height)
            case .failure(_):
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: self.width, height: self.height)
                    
            case .empty:
                ProgressView()
                    .frame(width: self.width, height: self.height)
            @unknown default:
                EmptyView()
                    .frame(width: self.width, height: self.height)
            }
        }
    }
}


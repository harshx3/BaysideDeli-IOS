//
//  StorageService.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 11/24/25.
//

import Foundation
import Supabase

final class StorageService {
    private let client: SupabaseClient
    private let bucketName = "sandwiches"

    init(client: SupabaseClient) {
        self.client = client
    }

    func getPublicImageURL(for path: String) -> String? {
        // 1. Add 'try?' before the call.
        // If it throws an error, 'url' becomes nil automatically.
        let url = try? client.storage
            .from(bucketName)
            .getPublicURL(path: path)

        // 2. Safely access absoluteString (if url is nil, this returns nil)
        return url?.absoluteString
    }
}

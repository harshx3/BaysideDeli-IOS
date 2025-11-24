//
//  MenuService.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 11/24/25.
//

import Foundation
import Supabase


final class MenuService {
    
    //We hold a reference to the single, shared supabase client
    private let client: SupabaseClient
    
    //table name in supabase
    private let menuTable = "menu_items"
    
    
    // Initializer to receive the shared client from SupabaseManager
    init(client: SupabaseClient) {
        self.client = client
    }
    
    func fetchMenuItems() async throws -> [MenuItem] {
        return try await client
            .from(menuTable)
            .select()
            .order("name", ascending: true)
            .execute()
            .value // safely decodes the result into the [MenuItem] type
    }
    
}

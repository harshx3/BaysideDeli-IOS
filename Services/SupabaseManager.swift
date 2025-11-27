//
//  SupabaseManager.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 11/27/25.
//

import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()
    let client: SupabaseClient
    
    private init() {
        
        guard let url = Secrets.projectURL else {
            fatalError("Project URL is not Found")
        }
        
        self.client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: Secrets.apiKey)
    }
}



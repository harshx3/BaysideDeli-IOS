//
//  AuthService.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 12/3/25.
//

import Foundation
import Supabase

struct AuthService {
    // Sign Up
    func signUp(email: String, password: String) async throws {
        let client = SupabaseManager.shared.client
        
        // This creates the user in the "auth.users" table
        let _ = try await client.auth.signUp(
            email: email,
            password: password
        )
    }
    
    // Sign In
    func signIn(email: String, password: String) async throws {
        let client = SupabaseManager.shared.client
        
        let _ = try await client.auth.signIn(
            email: email,
            password: password
        )
    }
    
    // Sign Out
    func signOut() async throws {
        try await SupabaseManager.shared.client.auth.signOut()
    }
    
    // Get current user (check if logged in)
    var currentUser: User? {
        // here supabase caches the session locally automatically
        SupabaseManager.shared.client.auth.currentUser
    }
    
}

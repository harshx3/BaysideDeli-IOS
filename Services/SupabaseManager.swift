//
//  SupabaseManager.swift
//  BaysideDeli
//
//  Created by Harsh Makwana on 11/23/25.
//

import Foundation
import Supabase

final class SupabaseManager {
    
    //Primary Supabase client instance
    let client: SupabaseClient
    
    //Services that will be managed by this central class
    //lazy means the sevices are initialized only when first accessed
//    private(set) lazy var authService = AuthService(client: client)
    private(set) lazy var menuService = MenuService(client: client)
//    private(set) lazy var storageService = StorageService(client: client)
    
    init() {
        //get configuration values from Info.plist which we have got from supabase web
        let databaseURL = (Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let anonKey = (Bundle.main.object(forInfoDictionaryKey: "ANON_KEY") as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        
        //validate and prepend "https://
        guard let url = URL(string: "https://" + databaseURL) else {
            fatalError("FATAL ERROR: Supabase URL is missing or invalid in Info.plist/Config.xcconfig. Check API_URL")
        }
        
        // Initialize the shared client
        self.client = SupabaseClient(supabaseURL: url, supabaseKey: anonKey)
        
    }
    
}
